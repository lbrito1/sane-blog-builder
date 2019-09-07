---
author: lbrito1
comments: true
created_at: 2015-09-20 17:26:58+00:00
kind: article
link: https://codedeposit.wordpress.com/2015/09/20/ruby-dsl-metaprogramming-part-ii/
slug: ruby-dsl-metaprogramming-part-ii
title: Ruby DSL & metaprogramming, part II
wordpress_id: 177
categories:
- Code
tags:
- DSL
- metaprogramming
- Ruby
---

In the previous installment we built a simple text generator using some Ruby meta-programming tricks. It was still far from being our desired context-free grammar (CFG) generator, though, since it lacked many [CFG prerequisites](https://www.cs.rochester.edu/~nelson/courses/csc_173/grammars/cfg.html). Most flagrantly, we had no rule recursion and only one production (rule definition) per rule. Here's the what a script that would use both features:

<div class="highlight"><pre><code class="language-bash">
dictionary
  noun 'dog', 'bus'
  verb 'barked', 'parked'
  preposition 'at'

rule 'phrase'
  opt 'The', noun, verb, preposition, 'a', noun
  opt 'Here goes some', phrase, 'recursion.'
  opt 'Meet me', preposition, 'the station.'

grammar phrase: 10
</code></pre></div>

The `dictionary` section is just as we left it. Let's see what changed in the `rule` section.

<!-- more -->

Previously we had only one production per rule, so rule definitions such as `phrase` were captured by the `method_missing` method. This design would make multiple productions difficult to handle. Here's how we re-implemented the rule method:

<div class="highlight"><pre><code class="language-ruby">
def rule *args
  verbose "Read rule: #{args.to_s}"
  @last_rule = args.first.to_s
  @grammar.rules[@last_rule] = (Rule.new @last_rule)
  define_method(args.first.to_s) { @grammar.rules[args.first.to_s] }
  @state = :rule
end
</code></pre></div>

Once more we use `define_method` to dynamically define methods. Consider the `rule 'phrase'` statement present in our script: this would define a method named `phrase` which hopefully returns the `Rule` object within `@grammar.rules['phrase']`. Note that the returned rule _is not_ evaluated (i.e., it is still a Rule object, not a String object).

Now we keep track of the `@last_rule` so rule productions (options) are added to the appropriate rule. Options are captures by `opt`:

<div class="highlight"><pre><code class="language-ruby">
def opt *args
  if @state == :rule
    verbose "Read option for rule #{@last_rule}: #{args.to_s}"
    @grammar.rules[@last_rule].options << args
  end
end
</code></pre></div>

Here, `args` is an array of Rule production symbols (both terminal and non-terminal, i.e., both Strings and Rules). The set of Rule options will ultimately be an Array of Arrays of Rule production symbols corresponding to each `opt` line written in the DSL script (e.g. in the example above, `phrase` would have 3 options).

Rules are evaluated by `Grammar.generate`, which receives a Hash of rules and the amount of times they should be generated (e.g. `phrase: 10` in our example):

<div class="highlight"><pre><code class="language-ruby">
  def generate args
    text = ''
    args.each do |rulename, qty|
      (1..qty).each { text << @rules[rulename.to_s].to_s }
    end
    puts "Final result: \n========\n#{text}\n========"
  end
</code></pre></div>

How does Rule recursion work, though? Let's take a look at the `to_s` method in `Rule`:

<div class="highlight"><pre><code class="language-ruby">
  def to_s
    randkeys = options.sample
    randkeys.map! { |k| k.to_s }
    verbose "Applying rule #{@name} with keys: #{randkeys}."
    randkeys.join(" ")
  end
</code></pre></div>

Pretty straightforward: a production is chosen at random (e.g., 1 of the 3 options in our example), and each symbol in the production is evaluated into a String and concatenated into the final result. For example, say the first rule, `opt 'The', noun, verb, preposition, 'a', noun`, is chosen. Then `randkeys.map!` would call `to_s` for each key in the production: `'The'.to_s, noun.to_s`, etc. Recursion will happen if the key is a method that returns a Rule object (such as the `phrase` method we mentioned in the beginning of the post).

Let's try out a CFG classic: [well-formed parenthesis](https://en.wikipedia.org/wiki/Context-free_grammar#Well-formed_parentheses). Here's the script:

<div class="highlight"><pre><code class="language-bash">
rule 'par'
  opt '()'
  opt '(', par, ')'
  opt par, par

grammar par: 1
</code></pre></div>

And here's some sample output:

<div class="highlight"><pre><code class="language-bash">
$ ruby lero.rb examples.le
Final result:
========
( ( ( ( () ) ) () ) () )
========
$ ruby lero.rb examples.le
Final result:
========
( () )
========
$ ruby lero.rb examples.le
Final result:
========
() ()
========
</code></pre></div>

And now we're done! With only 2 classes (Grammar and Rule) and 1 additional file that defines a DSL (lero.rb), we were able to build a CFG-like text generator with the most important CFG properties.

[Full code](https://github.com/lbrito1/ruby_textgen) is available in the same repository.
