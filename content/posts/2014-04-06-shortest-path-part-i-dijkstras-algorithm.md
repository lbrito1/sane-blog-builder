---
author: lbrito1
comments: true
created_at: 2014-04-06 23:21:02+00:00
kind: article
link: https://codedeposit.wordpress.com/2014/04/06/shortest-path-part-i-dijkstras-algorithm/
slug: shortest-path-part-i-dijkstras-algorithm
title: Shortest path, part I - Dijkstra's algorithm
wordpress_id: 124
categories:
- Code
tags:
- dijkstra
- graph
- graph search
- shortest path
---

Now that we have a way to represent [graphs]({% link _posts/2014-03-23-graph.markdown %}), we can discuss one of the most important problems in graph theory: the shortest path problem (SPP). More or less formally, we'll define SPP as:


Given a weighted graph G(V,E), find the sequence P = {v0, v1, v2, ..., v(n-1)}, vi ∈ V, from vertex V0 to vertex V(n-1), such that the list of edges EP = {(v0,v1), (v1,v2), ... (v(n-2), v(n-1))} exists and the summation of costs of all elements e ∈ EP is the smallest possible.


In other words, find the less expensive (ergo "shortest") path between two vertices.

The trivial solution is using [BFS]({% link _posts/2014-03-31-trees-part-i.markdown %}) starting at vertex A and stopping when it reaches vertex B. However, BFS doesn't look at the edge costs: it calculates the path with least edges, not the path with least total cost.

Although not necessarily the fastest, Dijkstra's algorithm is probably the most popular way to solve the shortest path problem due to its simplicity and elegance. The algorithm relies heavily on [priority queues]({% link _posts/2014-03-21-heap-priority-queues.markdown %}), so make sure to take a look at that if you haven't already.

**Pseudocode**

<div class="highlight"><pre><code class="language-bash">
dist[from] = 0
for v : G
      if v != source
            dist[v] = infinity
      prev[v] = -1
      PQ.add(v, dist[v])
while PQ.hasNext()
      u = PQ.pop()
      for each neighbor v of u
            alt = dist[u] + length(u, v)
            if alt < dist[v]
                  dist[v] = alt
                  prev[v] = u
                  PQ.decrease_key(v,alt)
return prev
</code></pre></div>

<!-- more -->

Lines 1-6 take care of initialization. Since we start at vertex "from", it is marked as having distance = 0. We haven't visited any other vertices yet, so we set there distances to infinity. prev[v] stores a pointer to vertex w such that by backtracking from v to prev[v] = w to prev[w] and so on we eventually arrive at vertex "from" by the shortest possible path. Since we don't know the shortest paths yet, all prevs are set to -1 (i.e. unknown). Every key-value pair (vertex, dist[vertex]) is stored in the priority queue.

Lines 7-14 calculate the shortest paths. The main loop (line 7) repeats |V| times, since there are |V| elements in the PQ. The min element _u_ is extracted at line 8 and lines 10-14 update the distances from u to all of u's neighbors (v), which is called edge relaxation: if dist[u] + length(u, v) is smaller than v's current distance, that means we've found a shorter path to v by going through u, so we update dist[v] and set prev[v] = u. Since the key-value pair (v,dist[v]) has changed, we update the priority queue with a decrease-key call (line 14).

As you may have noticed, Dijkstra's algorithm calculates the shortest path from one vertex to all the other vertices in the graph. So if we're only interested in the distance from one vertex to another, we may safely stop the algorithm after we've finished updating our target's neighbors, i.e. when u = target, because since it has been popped from the PQ, it won't ever be checked again.

As an example, here's how the algorithm works for the following graph (excerpt from the test output with _DEBUG flag):

[![graph1](/assets/images/codedeposit/2014/04/graph1.png)](/assets/images/codedeposit/2014/04/graph1.png)

**Weights (last parameter): **

<div class="highlight"><pre><code class="language-bash">
      add_edge(g, v0, v1, 2);
      add_edge(g, v0, v2, 3);
      add_edge(g, v1, v2, 1);
      add_edge(g, v2, v3, 1);
      add_edge(g, v4, v2, 1);
      add_edge(g, v4, v1, 1);
      add_edge(g, v5, v4, 1);
</code></pre></div>

**First iteration: ** since our starting point is v0, it gets popped first. Neighbors 1 and 2 are updated.

<div class="highlight"><pre><code class="language-bash">
NEIGHBORS OF v[0]:
--------------------
v[1]     optimal dist = 2       prev dist = 2147483647
v[2]     optimal dist = 3       prev dist = 2147483647
</code></pre></div>

**2nd & 3rd iteration: ** v[1] had the smallest distance in PQ, followed by v[2]. Their neighbors are updated.

<div class="highlight"><pre><code class="language-bash">
NEIGHBORS OF v[1]:
--------------------
v[0]     optimal dist = 4
v[2]     optimal dist = 3
v[4]     optimal dist = 3       prev dist = 2147483647


NEIGHBORS OF v[2]:
--------------------
v[0]     optimal dist = 6
v[1]     optimal dist = 4
v[3]     optimal dist = 4       prev dist = 2147483647
v[4]     optimal dist = 4
</code></pre></div>

**All the rest: **

<div class="highlight"><pre><code class="language-bash">
NEIGHBORS OF v[4]:
--------------------
v[2]     optimal dist = 4
v[1]     optimal dist = 4
v[5]     optimal dist = 4       prev dist = 2147483647


NEIGHBORS OF v[3]:
--------------------
v[2]     optimal dist = 5


NEIGHBORS OF v[5]:
--------------------
v[4]     optimal dist = 5
</code></pre></div>

**Final output (prev[] array):**

<div class="highlight"><pre><code class="language-bash">

Previous
===============

vert[0] -1
vert[1] 0
vert[2] 0
vert[3] 2
vert[4] 1
vert[5] 4
</code></pre></div>

i.e. the shortest path from 0 to 5 is: 0, 1, 4, 5. Path cost can be found at dist[vert5]. Verify that that's the shortest path: cost(0,1) = 2 (whilst cost(0,2) = 3), cost(1,4) = 1 and cost(4,5) = 1.

Below, the full code. We used our previously implemented [priority queues]({% link _posts/2014-03-21-heap-priority-queues.markdown %}) working as the PQ, and made the stop-at-target modification mentioned above. As always, updated source code and companion test code can be found @ github.

<div class="highlight"><pre><code class="language-c">

#include <limits.h>
#include "../tests/graph_test.c"
#include "../data_structures/heap.c"

int* dijkstra(graph* g, int from, int to)
{
      int nv = get_nv(g);

      int* dist         = malloc(sizeof(int)*nv);
      int* previous     = malloc(sizeof(int)*nv);
      heap* minheap = new_heap(nv, ORD_ASC, compare_kv);

      int i;
      for (i=0; i<nv; i++)
      {
            dist[i] = INT_MAX;
            previous[i] = -1;
            kv* val = new_kv(i, (void*) &dist[i], compare_integer);
            push(minheap, val);

            #ifdef _DEBUG
                  edge_iter* itd = new_edge_it(g,get_vertex(g,i));
                  edge* next = NULL;
                  while ((next = next_edge(itd)) != NULL) DBG("\n%d\tE(%lu,%lu) = %d",itd->idx,next->from->id,next->to->id,next->cost ) ;
                  free(itd);
            #endif
      }


      dist[from]        = 0;
      previous[from]    = -1;

      kv* min = NULL; int found = FALSE;
      while (((min = pop(minheap)) != NULL) && !found)
      {
            int u = min->k;
            visit_vert(g,u);

            edge_iter* it = new_edge_it(g,get_vertex(g,u));
            edge* next = NULL;


            DBG("\n\n\nNEIGHBORS OF v[%d]:\n--------------------",u);
            while ((next = next_edge(it)) != NULL)
            {
                  int v = next->to->id;
                  int ndist = dist[u] + next->cost;
                  DBG("\nv[%d]",v);
                  DBG("\t optimal dist = %d",ndist);

                  //relax edge
                  if ((ndist>=0) && (ndist<dist[v]) && (u!=v))
                  {
                        DBG("\tprev dist = %d",dist[v]);

                        dist[v]     = ndist;
                        previous[v] = u;

                        int vpos = -1;
                        kv* candidate = get_kv(minheap->array, minheap->heap_size, v, &vpos);
                        if (candidate !=NULL) update(minheap, vpos);
                  }
            }

            if (u==to) found = TRUE;
      }

      return previous;
}
</code></pre></div>

