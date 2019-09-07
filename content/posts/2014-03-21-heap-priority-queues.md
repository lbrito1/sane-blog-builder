---
author: lbrito1
comments: true
created_at: 2014-03-21 19:08:06+00:00
kind: article
link: https://codedeposit.wordpress.com/2014/03/21/heap-priority-queues/
slug: heap-priority-queues
title: Heap & Priority Queues
wordpress_id: 70
categories:
- Code
tags:
- abstract data structure
- data structure
- heap
- priority queue
- queue
---

Priority queues (PQs) are abstract data types that work just like regular stacks, but the popping order depends on each element’s priority instead of the sequence they were pushed onto the queue (FIFO or LIFO).

The naïve way of implementing a PQ consists of using an unsorted list or array and searching for the highest-priority element at each pop, which takes O(n) time. There are several more efficient implementations, of which the most usual is the heap.

Heaps are complete (i.e. all levels except possibly the last are filled) binary trees that work as PQs by maintaining the following property: children nodes always have a smaller priority than their parent, i.e. for any node A with children B and C, priority(B) < priority(A) && priority(C) < priority(A). Note that there is no assumed relation between siblings or cousins.

[![max-heap and corresponding array.](/assets/images/codedeposit/2014/03/heap.jpg)](/assets/images/codedeposit/2014/03/heap.jpg)
*max-heap and corresponding array.*

Each element of a heap has two pieces of information: a key and a value, hence we call them key-value (KV) pair. The key identifies the specific element, and the value determines the element’s priority within the heap. Heaps can be min-heaps (low value = high priority) or max-heaps (high value = high priority).

<!-- more -->

As any other data structure, we need at least the two basic operations: insert data and remove data. PQs also warrant an update priority operation. Here’s how we’ll implement those.

<div class="highlight"><pre><code class="language-c">
typedef struct {
      void** array;
      int array_size;
      int heap_size;
      int order;
      int (*cmp) (void*, void*);
} heap;
</code></pre></div>

First we have the heap structure. The binary tree is implemented as an array, using the following macros to get the child and parent indexes:

<div class="highlight"><pre><code class="language-c">

#define PARENT(i) i>>1
#define LEFT(i) i<<1
#define RIGHT(i) (i<<1)+1  </code></pre></div>

heap_size is the actual number of elements in the heap, and array_size is the maximum heap size. Here’s the initialization code for a heap struct:

<div class="highlight"><pre><code class="language-c">


/**
 *  @brief Create new heap data structure
 *
 *  @param [in] size    maximum heap size
 *  @param [in] ord     minheap: ORD_ASC, maxheap: ORD_DES
 *  @param [in] compare comparator
 *  @return Return_Description
 */
heap* new_heap(int size, int ord, int (*compare) (void*, void*))
{
      heap* h = malloc(sizeof(heap));
      h->array = malloc(sizeof(void*)*size+1);
      h->array_size = size+1;
      h->array[0] = NULL;     //very important!! baadf00d
      h->heap_size = 0;
      h->cmp = compare;
      h->order = ord;
      return h;
}


</code></pre></div>

Because we won’t be using array index 0 (since both children would also be 0), we need to remember two things: increasing by 1 the request maximum heap size (and allocating accordingly) and always filling aray[0] with something we know (preferably NULL) so we don’t get bogus memory reads if we do something wrong.

To maintain the heap property, we must use the heapify subroutine. Heapify works as following: given an array index i such that array[i] may have a lower priority than its children (thus violating the heap property), “float down” array[i] until it reaches the correct level, guaranteeing i is the root of a valid heap:

<div class="highlight"><pre><code class="language-c">

/**
 *  @brief Heapifies subtree rooted at h->array[idx], assuming
 *  that its two subtree children are already heaps. This is done
 *  by "floating down" the value at idx, which may violate heap
 *  condition, until it reaches the appropriate depth.
 *
 *  @param [in] h   Parameter_Description
 *  @param [in] idx Parameter_Description
 */
void heapify(heap* h, int idx)
{
      int l = LEFT(idx);
      int r = RIGHT(idx);
      int largest = idx;

      if (h->order == ORD_ASC)
      {
            if ((l<=h->heap_size) && (h->cmp(h->array[l], h->array[idx]) > 0)) largest = l;
            if ((r<=h->heap_size) && (h->cmp(h->array[r], h->array[largest]) > 0)) largest = r;
      }
      else if (h->order == ORD_DES)
      {
            if ((l<=h->heap_size) && (h->cmp(h->array[l], h->array[idx]) < 0)) largest = l;
            if ((r<=h->heap_size) && (h->cmp(h->array[r], h->array[largest]) < 0)) largest = r;       }              if (largest != idx)        {             exch(&h->array[idx], &h->array[largest]);
            heapify(h, largest);
      }
}
</code></pre></div>

The remaining operations are rather simple:

Pop removes array[1] (heap’s node with highest priority), replaces it with array[heapsize] and calls heapify at the heap root.

Push “floats up” the new value to be inserted starting at the bottom of the heap until it reaches the appropriate level.

Update (aka “decrease-key” or “increase-key”) changes the priority of a node and re-evaluates the heap so that it maintains heap property.

Full code can be found below and on my Github, at data_structures/heap.c. Runnable tests can be found in tests/test_heap.c

<div class="highlight"><pre><code class="language-c">


/*
    File: heap.c

    Copyright (c) 2014 Leonardo Brito <lbrito@gmail.com>

    This software is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write the Free Software Foundation, Inc., 51
    Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#include <stdlib.h>

#define PARENT(i) i>>1
#define LEFT(i) i<<1
#define RIGHT(i) (i<<1)+1
static inline void exch(void** a, void** b) { void* p = *a; *a = *b; *b = p; }

typedef struct {
      void** array;
      int array_size;
      int heap_size;
      int order;
      int (*cmp) (void*, void*);
} heap;

/**
 *  @brief Create new heap data structure
 *
 *  @param [in] size    maximum heap size
 *  @param [in] ord     minheap: ORD_ASC, maxheap: ORD_DES
 *  @param [in] compare comparator
 *  @return Return_Description
 */
heap* new_heap(int size, int ord, int (*compare) (void*, void*))
{
      heap* h = malloc(sizeof(heap));
      h->array = malloc(sizeof(void*)*size+1);
      h->array_size = size+1;
      h->array[0] = NULL;     //very important!! baadf00d
      h->heap_size = 0;
      h->cmp = compare;
      h->order = ord;
      return h;
}

/**
 *  @brief Heapifies subtree rooted at h->array[idx], assuming
 *  that its two subtree children are already heaps. This is done
 *  by "floating down" the value at idx, which may violate heap
 *  condition, until it reaches the appropriate depth.
 *
 *  @param [in] h   Parameter_Description
 *  @param [in] idx Parameter_Description
 */
void heapify(heap* h, int idx)
{
      int l = LEFT(idx);
      int r = RIGHT(idx);
      int largest = idx;

      if (h->order == ORD_ASC)
      {
            if ((l<=h->heap_size) && (h->cmp(h->array[l], h->array[idx]) > 0)) largest = l;
            if ((r<=h->heap_size) && (h->cmp(h->array[r], h->array[largest]) > 0)) largest = r;
      }
      else if (h->order == ORD_DES)
      {
            if ((l<=h->heap_size) && (h->cmp(h->array[l], h->array[idx]) < 0)) largest = l;
            if ((r<=h->heap_size) && (h->cmp(h->array[r], h->array[largest]) < 0)) largest = r;
      }

      if (largest != idx)
      {
            exch(&h->array[idx], &h->array[largest]);
            heapify(h, largest);
      }
}

/**
 *  @brief Builds a heap from an unsorted array (h->array)
 *
 *  @param [in] h
 */
void build_heap(heap* h)
{
      int i;
      for(i = h->heap_size>>1; i>0; i--) heapify(h, i);
}

/**
 *  @brief Pops min/maxval from heap
 *
 *  @param [in] h
 *  @return pointer to min/maxval
 */
void* pop(heap* h)
{
      if(h->heap_size<1) return NULL;
      void* max = h->array[1];
      h->array[1] = h->array[h->heap_size--];
      heapify(h,1);
      return max;
}

void* pop_at(heap* h, int pos)
{
      if(h->heap_size<1) return NULL;
      void* max = h->array[pos];
      h->array[pos] = h->array[h->heap_size--];
      heapify(h,pos);
      return max;
}



/**
 *  @brief Pushes value onto heap
 *
 *  @param [in] h
 *  @param [in] k
 *  @return FALSE if heap is full, TRUE otherwise
 */
int push(heap* h, void* k)
{
      if (k==NULL) return FALSE;
      if (h->heap_size == h->array_size - 1) return FALSE;
      h->heap_size++;

      int i = h->heap_size;

      if (i>1) {
            if (h->order == ORD_ASC)
                  for (i = h->heap_size; i>1 && h->cmp(h->array[PARENT(i)], k) < 0; i = PARENT(i)) h->array[i] = h->array[PARENT(i)];
            else if (h->order == ORD_DES)
                  for (i = h->heap_size; i>1 && h->cmp(h->array[PARENT(i)], k) > 0; i = PARENT(i)) h->array[i] = h->array[PARENT(i)];
      }

      h->array[i] = k;

      return TRUE;
}

/**
 *  @brief Brief
 *
 *  @param [in] h      Parameter_Description
 *  @param [in] pos    Parameter_Description
 *  @param [in] newval Parameter_Description
 *  @return Return_Description
 */
void update(heap* h, int pos)
{
      push(h, pop_at(h, pos));
}


</code></pre></div>
