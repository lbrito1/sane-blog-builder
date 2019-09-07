---
author: lbrito1
comments: true
created_at: 2014-02-21 05:46:17+00:00
kind: article
link: https://codedeposit.wordpress.com/2014/02/21/mergesort/
slug: mergesort
title: Mergesort
wordpress_id: 12
categories:
- Code
tags:
- sorting algorithm
---

Mergesort is an important sorting algorithm when you don't have efficient random memory access, since it doesn't rely on that and has good time complexity - O(n logn) specifically.

As a typical divide-and-conquer algorithm, Mergesort has two steps: first it recursively splits the lists in two until each half is unitary, then it recursively mends back the lists until it reaches the original size.

But before we dive into the actual algorithm, we need to make some changes to the linked list algorithm we'll be using.

<!-- more -->

On our previous post we weren't worried about instantiating multiple lists, but now we need a function that will do that and the data structure that will hold the necessary information:

<div class="highlight"><pre><code class="language-c">
typedef struct linked_list
{
      element *head;
      element *tail;
      unsigned size;
      int (*cmp) (void*, void*);
} linked_list;
</code></pre></div>

We now have a tail element: as we mentioned previously, having a tail handy allows us to reduce list-add time to O(1). Other than that we have the list size (number of elements) and a pointer to the compare function specific to whatever data type we want to use.

Okay, so let's get back to mergesort.

<div class="highlight"><pre><code class="language-c">

element* mergesort(linked_list* list, int order)
{
      linked_list *left = new_list(list->cmp);
      linked_list *right = new_list(list->cmp);

      if (list->head == NULL || list->head->next == NULL) return list->head;

      halve(list, left, right);

      element* merged = merge(mergesort(left, order),mergesort(right, order), list->cmp, order);

      free(left);
      free(right);

      return merged;
}
</code></pre></div>

Here we have divide step on line 8 (halve function) and conquer step on line 10 (merge function). On line 10, the first call to mergesort has precedence, so the algorithm will first recursively divide the left part of the list and then the right part - as in a pre-ordered traversal of a binary tree - and then go on to do the merging.

<div class="highlight"><pre><code class="language-c">
void halve(linked_list* list, linked_list* left, linked_list* right)
{
      element* middle = list->head;
      if (middle!=NULL) {
      int half = (int) ((list->size)/2.0f), i=0;
      while (++i<half) middle = middle->next;
      element* middle_head = middle->next;
      middle->next = NULL;

      left->head = list->head;
      left->size = (list->size)-half;

      right->head = middle_head;
      right->size = half;}
}
</code></pre></div>

Halving is simple: using the list size as a placemark, we find the middle element, set it as left half list's last element and set its successor as the head of the right half.

<div class="highlight"><pre><code class="language-c">

element* merge(element* a, element* b, int (*cmp) (void*, void*), int order)
{
      element* c = new_element(NULL);
      element* merged = c;
      while (a != NULL && b != NULL)
      {
            if ((order==ASC) ? (cmp(a->data, b->data) > 0) : (cmp(a->data, b->data) < 0))
            {
                  c->next = a;
                  a = a->next;
            }
            else
            {
                  c->next = b;
                  b = b->next;
            }
            c = c->next;
      }
      c->next = (a == NULL) ? b : a;
      return merged->next;
}

</code></pre></div>

To merge both lists, we stich together each half by comparing elements from both, one by one. Depending on the order (ascending/descending) we choose who comes first and set it as next on the consolidated list.

That's it! Fully runnable code can be found below as well as on github. After the code you can find compilation and expected output.

<div class="highlight"><pre><code class="language-c">
/*
    File: mergesort.c

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

#include "linked_list.c"
#include <time.h>
#include <stdlib.h>

#if !defined _TEST_SIZE_MSORT && defined _DEBUGGING
#define _TEST_SIZE_MSORT 10
#endif

#define ASC 0
#define DEC 1

element* mergesort(linked_list* list, int order);
void halve(linked_list* list, linked_list* left, linked_list* right);
element* merge(element* a, element* b, int (*cmp) (void*, void*), int order);

/**
 *  @brief Orders the list using mergesort
 *
 *  @param [in] list  Linked list
 *  @param [in] order Sorting order (ASC or DEC)
 *  @return partial result, used for recursion only
 */
element* mergesort(linked_list* list, int order)
{
      linked_list *left = new_list(list->cmp);
      linked_list *right = new_list(list->cmp);

      if (list->head == NULL || list->head->next == NULL) return list->head;

      halve(list, left, right);

      element* merged = merge(mergesort(left, order),mergesort(right, order), list->cmp, order);

      free(left);
      free(right);

      return merged;
}

/**
 *  @brief Splits a list into two halves
 *
 *  @param [in] list  Original list
 *  @param [in] left  Left half
 *  @param [in] right Right half
 */
void halve(linked_list* list, linked_list* left, linked_list* right)
{
      element* middle = list->head;
      if (middle!=NULL) {
      int half = (int) ((list->size)/2.0f), i=0;
      while (++i<half) middle = middle->next;
      element* middle_head = middle->next;
      middle->next = NULL;

      left->head = list->head;
      left->size = (list->size)-half;

      right->head = middle_head;
      right->size = half;}
}

/**
 *  @brief Merges two lists into a single list
 *
 *  @param [in] a   First half
 *  @param [in] b   Second half
 *  @param [in] cmp Comparator function
 *  @return Pointer to consolidated list's head
 */
element* merge(element* a, element* b, int (*cmp) (void*, void*), int order)
{
      element* c = new_element(NULL);
      element* merged = c;
      while (a != NULL && b != NULL)
      {
            if ((order==ASC) ? (cmp(a->data, b->data) > 0) : (cmp(a->data, b->data) < 0))
            {
                  c->next = a;
                  a = a->next;
            }
            else
            {
                  c->next = b;
                  b = b->next;
            }
            c = c->next;
      }
      c->next = (a == NULL) ? b : a;
      return merged->next;
}

//#ifdef _DEBUGGING
int main()
{
      linked_list* list = new_list(compare_integer);

      srand(time(NULL));

      int* x = malloc(sizeof(int)*_TEST_SIZE_MSORT);

      int i=0;
      for (;i<_TEST_SIZE_MSORT;i++)
      {
            x[i] = rand();
            add(list, &(x[i]));
      }

      element* xx = list->head;
      i=0;
      do { printf("\n[%d]\t%d",i++,*((int*)xx->data));
      } while ((xx=xx->next)!=NULL);

      printf("\n\nSorted:");
      xx = mergesort(list, DEC);
      list->head = xx;
      i=0;
      do { printf("\n[%d]\t%d",i++,*((int*)xx->data));
      } while ((xx=xx->next)!=NULL);

      return 0;
}
//#endif
</code></pre></div>

<div class="highlight"><pre><code class="language-bash">
C:\code\c\cstuff>gcc mergesort.c -o mergesort -D _TEST_SIZE_MSORT=20 -D DEBUGGING

C:\code\c\cstuff>mergesort

[0]     2549
[1]     30801
[2]     23795
[3]     9308
[4]     8425
[5]     23253
[6]     26244
[7]     32399
[8]     3802
[9]     30628
[10]    18291
[11]    29682
[12]    11105
[13]    23618
[14]    23104
[15]    11222
[16]    7193
[17]    1327
[18]    8573
[19]    30288

Sorted:
[0]     32399
[1]     30801
[2]     30628
[3]     30288
[4]     29682
[5]     26244
[6]     23795
[7]     23618
[8]     23253
[9]     23104
[10]    18291
[11]    11222
[12]    11105
[13]    9308
[14]    8573
[15]    8425
[16]    7193
[17]    3802
[18]    2549
[19]    1327
</code></pre></div>
