---
author: lbrito1
comments: true
created_at: 2014-02-14 04:47:03+00:00
kind: article
link: https://codedeposit.wordpress.com/2014/02/14/3/
slug: 'linked-list'
title: Linked List
wordpress_id: 3
tags:
- data structure
- list
---

Here's a very simple implementation of the linked list data structure.

A pointer to the head element is enough to define a linked list. Each element consists of one pointer to the subsequent element in the list and one pointer to the element's data:

[![linkedlist](/assets/images/codedeposit/2014/02/linkedlist.png?w=450)](/assets/images/codedeposit/2014/02/linkedlist.png)

<!-- more -->

So we'll start with the data structure itself. Namely, the Element struct:

<div class="highlight"><pre><code class="language-c">
typedef struct Element
{
      void *data_ptr;
      struct Element *next;
} Element;
</code></pre></div>


Simple enough: each element has one data pointer and one pointer to the next element, just as we defined.

Next, we need the 3 basic list element operations: add, remove and find. Since creating a new list is a matter of creating a new element and setting it as "head", we're omitting that.

<div class="highlight"><pre><code class="language-c">
void add(Element *list_head, void *data)
{
      Element *e = list_head;
      while (e->next != NULL) e = e->next;
      Element *toadd = new_element(data);
      e->next = toadd;
}
</code></pre></div>


To add data to a list, first we find the last element (i.e., next=NULL) by traversing the list. Next we create a new element with the data we're adding, and point the last element to it, so now it is the last element. This costs O(n). A more efficient way of doing this is keeping a pointer to the last element so we don't have to traverse the list at all, resulting in O(1) cost.

<div class="highlight"><pre><code class="language-c">
Element *search(void *list_head, void *data)
{
      Element *e = list_head;
      Element *prev = e;
      // exception for list head
      if (compare(data, e->data_ptr)) return NULL;
      do
      {
            if (compare(data, e->data_ptr)) return prev;
            prev = e;
      } while ((e = e->next) != NULL);
      return NULL;
}
</code></pre></div>


Searching is trivial: we traverse the list and return the pointer to the element whose subsequent element is the one we're looking for. This costs O(n). The reason we want to get our hands on the _previous_ element and not the element itself will be explained later. Also, we make a necessary exception for the list head, since there is no previous element to it and it does not carry data (in our implementation).

<div class="highlight"><pre><code class="language-c">
int delete(Element *list_head, void *data)
{
      Element *searched = search(list_head, data);
      if (searched)
      {
            Element *removed = searched->next;
            searched->next = searched->next->next;
            free(removed->data_ptr);
            free(removed);
            return TRUE;
      }
      else return FALSE;
}
</code></pre></div>


To remove an element, first we do a search in the list for the element we want deleted. The reason we wanted the pointer to the _previous_ element is that after we do the removal, we'll need to re-link the list: if we have A B C and remove B, A->next must point to C. If we have 3 or more elements this is trivial. If there are only 2 elements and we remove one of them (i.e. "C" in our example is NULL), then A->next will point to NULL and will become the first and last element, as expected.

That's all we need for a linked list! Below you can find the full runnable code and the expected output.

<div class="highlight"><pre><code class="language-c">

//======================
//      Linked list
// CC-BY Leonardo Brito
// lbrito@gmail.com
//======================

#include
#include
#include

#define TRUE 1
#define FALSE 0

#ifndef TEST_SIZE
#define TEST_SIZE 10
#endif

//======================
//          Algorithm
//======================

typedef struct Element
{
      void *data_ptr;
      struct Element *next;
} Element;

int compare(void *data1, void *data2);

Element *search(void *list_head, void *data);

Element *new_element(void *data)
{
      Element *e = (Element*) malloc(sizeof(Element));
      e->data_ptr = data;
      e->next = NULL;
      return e;
}

int compare(void *data1, void *data2)
{
      return (strcmp((char*) data1, (char*)data2) == 0 ? TRUE : FALSE);
}

void add(Element *list_head, void *data)
{
      Element *e = list_head;
      while (e->next != NULL) e = e->next;
      Element *toadd = new_element(data);
      e->next = toadd;
}

Element *search(void *list_head, void *data)
{
      Element *e = list_head;
      Element *prev = e;
      if (compare(data, e->data_ptr)) return NULL; // exception for list head
      do
      {
            if (compare(data, e->data_ptr)) return prev;
            prev = e;
      } while ((e = e->next) != NULL);
      return NULL;
}

int delete(Element *list_head, void *data)
{
      Element *searched = search(list_head, data);
      if (searched)
      {
            Element *removed = searched->next;
            searched->next = searched->next->next;
            free(removed->data_ptr);
            free(removed);
            return TRUE;
      }
      else return FALSE;
}

//======================
//          Tests
//======================

Element *build_list()
{
      char *head_data = "I'm the (permanent) list head. You can't delete me.";
      Element *head = new_element(head_data);
      char *basetext = "I'm element number ";
      int i=1;
      for (;i<TEST_SIZE;i++)        {             char *text1 = malloc(sizeof(char)*strlen(basetext));             strcpy(text1, basetext);             char numb[10];             sprintf(numb, "%d", i);             strcat(text1, numb);             add(head, text1);       }              return head; } void print_list(Element *head)  {       printf("\n==============");       Element *e = head;       int i = 0;       do        {             printf("\nList [%d]:\t%s",i++,(char**)e->data_ptr);
      } while ((e = e->next) != NULL);
      printf("\n==============\n");
      return head;
}

void test_delete(Element *head, int eln)
{
      char data[20];
      sprintf(data, "I'm element number %d", eln);
      if (delete(head, data)) printf("\nSuccessfully deleted element #%d",eln);
}

void test_add(Element *head, int eln)
{
      char *data = malloc(sizeof(char)*50);
      sprintf(data, "I'm NEW element number %d", eln);
      add(head, data);
      printf("\nSuccessfully added NEW element #%d",eln);
}

int main()
{
      Element *head = build_list();

      print_list(head);
      test_delete(head, 1);
      test_delete(head, 2);
      test_delete(head, 3);
      test_delete(head, 4);
      test_delete(head, 5);
      test_delete(head, 6);
      test_delete(head, 7);
      test_delete(head, 8);
      test_delete(head, 9);
      print_list(head);
      test_add(head, 1337);
      test_delete(head, 2);
      test_add(head, 98);
      print_list(head);

      return 0;
}

</code></pre></div>

<div class="highlight"><pre><code class="language-c">
C:\code\c\cstuff>linked_list

==============
List [0]:       I'm the (permanent) list head. You can't delete me.
List [1]:       I'm element number 1
List [2]:       I'm element number 2
List [3]:       I'm element number 3
List [4]:       I'm element number 4
List [5]:       I'm element number 5
List [6]:       I'm element number 6
List [7]:       I'm element number 7
List [8]:       I'm element number 8
List [9]:       I'm element number 9
==============

Successfully deleted element #1
Successfully deleted element #2
Successfully deleted element #3
Successfully deleted element #4
Successfully deleted element #5
Successfully deleted element #6
Successfully deleted element #7
Successfully deleted element #8
Successfully deleted element #9
==============
List [0]:       I'm the (permanent) list head. You can't delete me.
==============

Successfully added NEW element #1337
Successfully added NEW element #98
==============
List [0]:       I'm the (permanent) list head. You can't delete me.
List [1]:       I'm NEW element number 1337
List [2]:       I'm NEW element number 98
==============
</code></pre></div>

