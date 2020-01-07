---
author: lbrito1
comments: true
created_at: 2014-03-18 02:18:40+00:00
kind: article
link: https://codedeposit.wordpress.com/2014/03/17/doubly-linked-list/
slug: doubly-linked-list
title: Doubly linked list
wordpress_id: 30
categories:
- Code
tags:
- data structure
- list
---

A doubly linked list is like our previously implemented Linked List, but instead of only having pointers to the next element, it also has pointers to the _previous _element:

[![610px-Doubly-linked-list.svg](/assets/images/codedeposit/2014/03/610px-doubly-linked-list-svg.png)](/assets/images/codedeposit/2014/03/610px-doubly-linked-list-svg.png)

This property makes the doubly linked list very useful as a base for other data structures such as the stack: having a previous pointer means we can quickly (O(1)) remove objects from the list's tail, which would be impossible with a linked list.

We won't discuss implementation since it so similar to a linked list. If anything implementation is even simpler than a linked list because of the previous pointer access.

<!-- more -->

Full source code with printable tests follows below, and can also be found at out github.

<div class="highlight"><pre><code class="language-c">
/*
    File: doubly_linked_list.c

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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "comparators.c"

#if !defined _TEST_SIZE_LIST && defined _DEBUGGING
#define _TEST_SIZE_LIST 10
#endif

#define TRUE 1
#define FALSE 0

typedef struct d_element
{
      void *data;
      struct d_element *next, *prev;
} d_element;

typedef struct d_linked_list
{
      d_element *head;
      d_element *tail;
      unsigned size;
      int (*cmp) (void*, void*);
} d_linked_list;

/**
 *  @brief create a new doubly linked list
 *
 *  @param [in] comparator
 *  @return
 */
d_linked_list *new_list(int (*comparator) (void*, void*))
{
      d_linked_list *l = malloc(sizeof(d_linked_list));
      l->size = 0;
      l->cmp = comparator;
      return l;
}

/**
 *  @brief create a new d_element
 *
 *  @param [in] data
 *  @return
 */
d_element *new_d_element(void *data)
{
      d_element *e = (d_element*) malloc(sizeof(d_element));
      e->data = data;
      e->next = NULL;
      e->prev = NULL;
      return e;
}

/**
 *  @brief add data to list
 *
 *  @param [in] list
 *  @param [in] data
 */
void add(d_linked_list *list, void *data)
{
      if (list->size == 0)
      {
            list->head = new_d_element(data);
            list->tail = list->head;
      }
      else
      {
            d_element *toadd = new_d_element(data);
            list->tail->next = toadd;
            toadd->prev = list->tail;
            list->tail = toadd;
      }
      ++list->size;
}

/**
 *  @brief search for data in list
 *
 *  @param [in] list
 *  @param [in] data
 *  @return searched element
 */
d_element *search(d_linked_list *list, void *data)
{
      d_element *e = list->head;
      do
      {
            if (list->cmp(data, e->data) == 0) return e;
      } while ((e = e->next) != NULL);
      return NULL;
}

/**
 *  @brief delete data from list
 *
 *  @param [in] list
 *  @param [in] data
 *  @return TRUE if data was found & deleted, FALSE otherwise
 */
int delete(d_linked_list *list, void *data)
{
      d_element *searched = search(list, data);
      if (searched)
      {
            int ishead = !list->cmp(searched->data, list->head->data);
            if (!ishead)
            {
                  if (searched != NULL)
                  {
                        searched->next->prev = searched->prev;
                        searched->prev->next = searched->next;
                  }
                  else
                  {
                        list->head = NULL;      // LAST ELEMENT IN LIST
                        list->tail = NULL;
                  }
            }
            else
            {
                  if (list->head->next != NULL)
                  {
                        list->head = list->head->next;
                        list->head->prev = NULL;
                  }
                  else
                  {
                        list->head = NULL;      // LAST ELEMENT IN LIST
                        list->tail = NULL;
                  }
            }
            free(searched->data);
            free(searched);
            --list->size;
            return TRUE;
      }
      else return FALSE;
}

#ifdef _DEBUGGING

d_linked_list *build_list()
{
      d_linked_list *list = new_list(compare_string);
      char *basetext = "I'm d_element number ";
      int i=1;
      for (;i<_TEST_SIZE_LIST;i++)
      {
            char *text1 = malloc(sizeof(char)*(strlen(basetext)+10));
            strcpy(text1, basetext);
            char numb[10];
            sprintf(numb, "%d", i);
            strcat(text1, numb);
            add(list, text1);
      }

      return list;
}

void print_list(d_linked_list *list)
{
      if (list->size == 0)
      {
            printf("\nList empty.");
      }
      else
      {
            printf("\n==============");
            d_element *e = list->head;
            int i = 0;
            do
            {
                  printf("\nList [%d]:\t%s",i++,(char*)e->data);
            } while ((e = e->next) != NULL);
            printf("\n==============\n");
      }
}

void test_delete(d_linked_list *list, int eln)
{
      char data[20];
      sprintf(data, "I'm d_element number %d", eln);
      if (delete(list, data)) printf("\nSuccessfully deleted d_element #%d, %d elems in list",eln,list->size);
      else printf("\nElem #%d not found",eln);
}

void test_add(d_linked_list *list, int eln)
{
      char *data = malloc(sizeof(char)*50);
      sprintf(data, "I'm NEW d_element number %d", eln);
      add(list, data);
      printf("\nSuccessfully added NEW d_element #%d, %d elems in list",eln,list->size);
}

int main()
{
      d_linked_list *list = build_list();

      print_list(list);
      test_delete(list, 1);
      test_delete(list, 2);
      test_delete(list, 7);
      test_delete(list, 3);
      test_delete(list, 4);
      test_delete(list, 5);
      test_add(list, 13);
      test_delete(list, 6);
      test_delete(list, 8);
      test_delete(list, 9);
      print_list(list);
      test_add(list, 1337);
      print_list(list);
      test_delete(list, 2);
      test_add(list, 98);
      print_list(list);

      return 0;
}

#endif
</code></pre></div>