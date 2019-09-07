---
author: lbrito1
comments: true
created_at: 2014-04-21 19:37:30+00:00
kind: article
link: https://codedeposit.wordpress.com/2014/04/21/trees-part-ii-avl-tree/
slug: trees-part-ii-avl-tree
title: 'Trees, Part II: AVL Tree'
wordpress_id: 134
categories:
- Code
tags:
- avl
- binary search tree
- bst
- data structure
- tree
---

Masters classes started a few weeks ago, taking their toll on my productivity here. Sorry about that!

So we (pardon the [nosism](http://en.wikipedia.org/wiki/Nosism), but I think it sounds less egocentric than writing "I" all the time) hinted at AVL trees back on our [Trees, Part I]({% link _posts/2014-03-31-trees-part-i.markdown %}) post. Specifically, we learned that:


<blockquote>a binary search tree (BST), provides O(h) time search, insert and delete operations (h is the tree height.</blockquote>


Linear time (O(h)) doesn't sound very good - if h is close to n, we'll have the same performance as a [linked list]({% link _posts/2014-02-14-3.markdown %}}). What if there were a way to bound the tree height to some sub-linear factor? As it turns out, there are several ways to do so, and the general idea of somehow keeping the tree height limited to a certain factor of the number of elements it holds is called height **balancing**. Ergo we'll want to look into (height) **balanced/self-balancing binary search trees **(BBST)**. **

<div class="highlight"><pre><code class="language-bash">

                      Burger


                          M
                        .   .
                      .       .
                    .           .
                  .               .
                E .                 P .
              .     .                   .
            .         .                   .
          .             .                   .
      D .                 I                   Y
                        .
                      .
                    .
                  .
                F
</code></pre></div>



_AVL tree_


Since binary search trees have at most two children, the best tree height (i.e. smallest) we can achieve is log2 n (n being the number of elements in the tree). There are [several ](http://en.wikipedia.org/wiki/Self-balancing_binary_search_tree)self-balancing BSTs developed over the years. It seems that up there in the US college professors tend to prefer the red-black tree when studying BBSTs, whilst over here AVL is preferred. In any case, AVL tree was the first BBST ever devised, so we'll adopt it as our BBST model.

AVL trees (named after its two Soviet inventors Adelson-Velsky and Landis) use a series of **rotations** to keep the tree balanced. To keep track of when a certain subtree rooted at some node needs to be rotated, we maintain (or calculate) a **balance factor** variable for each node, which is the difference between the node's left and right children's heights, i.e.:


balance_factor(n) = n.left_child.height - n.right_child.height




<!-- more -->


AVL trees allow balance factors of -1, 0 or +1. That means that for any given node, the difference between the heights of its left and right subtrees will be at most 1. [Doing the math](http://lcm.csa.iisc.ernet.in/dsa/node112.html) on that, it can be proven that AVL trees have at most height 1.44log n, which is pretty good sub-linear time.

So how we keep every node's balance factor between -1 and 1? Suppose a node has +1 balance factor and we insert data on the node's left subtree in such a way that now the node has a balance factor of +2. If we could re-arrange the elements inside the node's child subtrees in a way that the root node now had zero balance, that would solve our problem. If we did so for each node in the path between the inserted node and the tree root (which we call **branch**), we would guarantee the AVL property.

This re-arrangement we talk of is called tree rotation. The goal of a tree rotation is always the same: given an unbalanced (i.e. balance factor greater than 1 or smaller than -1) node n, re-arrange its children in a manner that preserves BST property and makes n balanced, ideally with perfect (zero) balance.

Although rotation is always the same, to facilitate implementation and learning literature splits it in two groups: left (+2) and (-2) right rotation, each with two subgroups: left-left/left-right and right-right/right-left. Left and right rotation are symmetrical, so we only need to focus on one of them.

Suppose a node X with children Z (to the left) and D (right) has balance factor +2. Suppose that both Z and D are roots to subtrees that maintain AVL property, i.e. all of their nodes have -1, 0 or +1 balance factor.

Depending on Z's balance factor, we'll need to do a left-left or a left-right rotation. Left-left (and its symmetrical right-right) rotations are the easiest, whilst in left-right rotations we first rotate the tree in a way that we can do a left-left rotation, so we end up doing two rotations to get a balanced tree.

There is no easier way to explain rotations than by drawing them. The following drawing can be found in the code, commented:

<div class="highlight"><pre><code class="language-bash">

  LEFT-RIGHT CASE        LEFT-LEFT CASE             BALANCED
  (Y bal = -1)            (Y bal = +1)

       +2                      +2                    (0)
          X                       X                      Z
         / \                     / \                    /  \
    -1  /   D               +1  /   D                  /    \
       Y            \          Z              \       Y      X
      / \        ----\        / \          ----\     / \    / \
     A   \       ----/       /   C         ----/    A   B  C   D
          Z         /       Y                 /
         / \               / \
        B   C             A   B


</code></pre></div>



Rotation may seem somewhat esoteric at first, but once you focus on what is going on with the main nodes (X,Y,Z) all the rest unfolds naturally. In the left-left rotation, Z is the value between X and Y, so naturally we want to choose him as the new root, replacing X. By doing that, Y continues to be Z's left child, but X, which is greater than Z and was its parent before, now is its right child. The same logic applies to subchildren A through D. Once you understand the mechanism behind rotations, you won't even need to memorize anything.

Right-right and right-left rotations are symmetrical. You can find their graphics in the code comments.

As we mentioned before, rotations are all we need to maintain AVL property: each time we insert a node, we check for AVL violations (i.e. balance factor = +2 or -2) bottom-up starting at the inserted node and ending at the tree root. A correctly implemented AVL tree will never have balance factors greater than +2 or smaller than -2 even before rotations, so those are the only two cases you need to check for.

Here's an example of a left-right rotation:

<div class="highlight"><pre><code class="language-bash">

BEFORE INSERTING E

                    Burger





                        M
                      .   .
                    .       .
                  .           .
                .               .
              I                   P
            .
          .
        .
    D .



AFTER INSERTING I AND MAKING A LR ROTATION

                           Burger





                               M
                             .   .
                           .       .
                         .           .
                       .               .
                     E .                 P
                   .     .
                 .         .
               .             .
           D .                 I

</code></pre></div>



And here's a right-right rotation after inserting 'T':

<div class="highlight"><pre><code class="language-bash">

BEFORE
               Burger





                   I
                 .   .
               .       .
             .           .
           .               .
         G                   O .
                           .     .
                         .         .
                       .             .
                   N .                 R




AFTER
                        Burger





                            O
                          .   .
                        .       .
                      .           .
                    .               .
                  I .                 R .
                .     .                   .
              .         .                   .
            .             .                   .
        G .                 N                   T



</code></pre></div>

Compiling the code with _DEBUGGING and _VERBOSE defined renders a very comprehensive analysis of what's going on before, during and after each insert and rotation. If you're learing AVL it can be a very useful tool - just run the test several times and look at what rotations are being made, and how they work. Just look at the output.

I'm not going to bother with full code this time, given that the nature of rotations makes the code extremely obnoxious both to implement, debug and even look at, mainly because of all the pointer swapping business with C. In Java it would probably look much nicer.

Just so you have an idea, this is what a left rotation looks like:

<div class="highlight"><pre><code class="language-c">

// LEFT ROTATION
      if (bal == 2)
      {
            // LEFT-RIGHT
            if (n->left_child->bal == -1)
            {
                  DBG("LR ROTATION...");

                  x = n;
                  y = x->left_child;
                  z = y->right_child;

                  a = y->left_child;
                  b = z->left_child;
                  c = z->right_child;
                  d = x->right_child;

                  x->left_child = z;
                  z->parent = x;
                  z->left_child = y;
                  y->parent = z;
                  y->right_child = b;
                  if (b) b->parent = y;
            }
            // LEFT-LEFT

            DBG("LL ROTATION\n\n");

            x = n;
            z = x->left_child;
            y = z->left_child;

            DBG("XYZ = %c, %c, %c\n",
            *(int*)x->data,*(int*)y->data,*(int*)z->data);

            a = y->left_child;
            b = y->right_child;
            c = z->right_child;
            d = x->right_child;


            z->parent = x->parent;

            if (x->parent)
            {
                  if ((x->parent->left_child) && (x->parent->left_child == x))
                        z->parent->left_child = z;
                  else if ((x->parent->right_child) && (x->parent->right_child == x))
                        z->parent->right_child = z;
            }
            z->right_child = x;
            x->parent = z;
            x->left_child = c;
            if (c) c->parent = x;


            y->height =
                  (a&&b) ? fmax(a->height, b->height) :
                  a ? a->height :
                  b ? b->height : -1;
            y->height++;

            x->height =
                  (c&&d) ? fmax(c->height, d->height) :
                  c ? c->height :
                  d ? d->height : -1;
            x->height++;

            z->height = fmax(x->height, y->height);
            z->height++;

            return z;

      }

</code></pre></div>

Not nice at all!

We are, however, going to take a brief look at the rebalance function, which does the basic housekeeping after each insertion and calls the appropriate rotation.

<div class="highlight"><pre><code class="language-c">


/**
 *  @brief Recalculate heights in all nodes
 *  affected by a insertion, i.e. every node
 *  in the branch traversed during insertion.
 *
 *  After recalculating lheight and rheight
 *  of a node, calculte balance (lh-rh) and
 *  call the apropriate rotation case if
 *  bal = -2 or +2. bal should always an
 *  element of the set {-2, -1, 0, 1, 2}.
 *
 *  Should be called after insertion.
 *
 *                ------------
 *                |   COST   |
 *                ------------
 *
 *  O(log n) worst case
 *
 *  Rebalance is called each time an insertion
 *  is done, and receives the inserted node
 *  as parameter. Of course, the inserted node
 *  is always a leaf (before the rotations).
 *
 *  In a balanced BST, the difference between
 *  any two leaves' depth (distance to tree root)
 *  is at most some constant k: in AVL trees, k
 *  is at most 1 - whenever k exceeds 1, we rotate
 *  the subtree.
 *
 *  Therefore the AVL tree is guaranteed to have
 *  height h = log2 n, where n is the number of
 *  elements currently in the tree. The loop in
 *  this function will repeat at most log2 n
 *  times, resulting in O(log n) worst case time.
 *
 *
 *  @param [in] bt   Parameter_Description
 *  @param [in] leaf Parameter_Description
 *  @return Return_Description
 */
void rebalance(binary_tree* bt, node* leaf)
{
      DBG("\n\nSTARTED CHECKING NODE %d (%c)\n=====================\n\n",
      *(int*)leaf->data,*(int*)leaf->data);

      int branch_h = 0;
      node* next = leaf;
      while (next)
      {
            DBG("\nnode in path %d (%c)\n-----------------\n",
            *(int*)next->data,*(int*)next->data);

            if (branch_h > next->height)
            {
                  next->height = branch_h;
                  DBG("Node %d new height: %d\n",*(int*)next->data, next->height);
            }


            if (next)
            {
                  int lh = 0;
                  if (next->left_child) lh = next->left_child->height+1;
                  int rh = 0;
                  if (next->right_child) rh = next->right_child->height+1;

                  next->bal = lh-rh;
                  DBG("Node %d (%c)\tlh=%d, rh=%d\tBAL = %d\n",
                  *(int*)next->data,*(int*)next->data,lh,rh,next->bal);
            }



            #ifdef _VERBOSE
            DBG("\n====================\nBefore rotate\n=============\n\n");
            clean_burger(burg);
            print_tree(burg,bt->root,0.5,0.1, 0);
            print_burger(burg);
            #endif

            node* new_subtree_root = rotate(next);
            if (new_subtree_root)
            {
                  next = new_subtree_root;
            }

            node* r = bt->root;
            while (r)
            {
                  bt->root = r;
                  DBG("R %d\t",*(int*)r->data);

                  r = r->parent;
            }

            #ifdef _VERBOSE
            if (new_subtree_root)
            {
            DBG("\n====================\nAfter rotate\n=============\n\n");
            clean_burger(burg);
            print_tree(burg,bt->root,0.5,0.1, 0);
            print_burger(burg);
            }
            #endif

            DBG("Finished checking node %d (%c), now checking " ,*(int*) next->data, *(int*) next->data);
            next = next->parent;
            if(next) DBG("\tnode %d (%c)\n" ,*(int*) next->data, *(int*) next->data);
            else DBG("(NULL - finished branch)\n");

            branch_h++;
      }
}
</code></pre></div>

The main while loop starts at the inserted node (leaf) and repeats until it reaches the tree root. The most important thing done here is updating each node's height, which makes it possible to calculate node balance factor later. This is done in the first and second if, respectively. After the new balance factor is calculated, the node is passed to the rotate function, which decides based on its balance factor if it needs any of the four rotations. After the rotation, the tree root might have changed, so we make sure we keep the correct root (node* new_subtree_root and the subsequent while loop). Finally, if debugging is defined, we print the tree using [BurgerGFX]({% link _posts/2014-03-18-burgergfx-simple-2d-graphics.markdown %}) and increment the loop (i.e. next = next->parent and branch_height++).

You can see how this works by using the debug flags. For example, in the right-right rotation we showed above (inserting 'T' into the tree), here's the console output which shows us what's going on in the rebalance function:

<div class="highlight"><pre><code class="language-bash">
STARTED CHECKING NODE 84 (T)
=====================


node in path 84 (T)
-----------------
Node 84 (T)     lh=0, rh=0      BAL = 0

ROTATING NODE 84 (T)... R 73
Finished checking node 84 (T), now checking     node 82 (R)

node in path 82 (R)
-----------------
Node 82 new height: 1
Node 82 (R)     lh=0, rh=1      BAL = -1

ROTATING NODE 82 (R)... R 73
Finished checking node 82 (R), now checking     node 79 (O)

node in path 79 (O)
-----------------
Node 79 new height: 2
Node 79 (O)     lh=1, rh=2      BAL = -1

ROTATING NODE 79 (O)... R 73
Finished checking node 79 (O), now checking     node 73 (I)

node in path 73 (I)
-----------------
Node 73 new height: 3
Node 73 (I)     lh=1, rh=3      BAL = -2

ROTATING NODE 73 (I)... RR ROTATION

R 73    R 79
Finished checking node 79 (O), now checking (NULL - finished branch)
</code></pre></div>

You may have noticed we didn't mention deletion. Correct - I chose not to implement it. Full code can be found on github.


