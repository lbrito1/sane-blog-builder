---
author: lbrito1
comments: true
created_at: 2014-03-18 02:57:20+00:00
kind: article
link: https://codedeposit.wordpress.com/2014/03/17/burgergfx-simple-2d-graphics/
slug: burgergfx-simple-2d-graphics
title: BurgerGFX - simple 2D graphics
wordpress_id: 53
excerpt: "Several times I find myself wanting to visualize something in 2D, but can't bother to fire up OpenGL or other cumbersome API."
categories:
- Code
tags:
- graphics
---

[![sample code and output](/assets/images/codedeposit/2014/03/burger_gfx1.jpg)](/assets/images/codedeposit/2014/03/burger_gfx1.jpg)

Several times I find myself wanting to visualize something in 2D, but can't bother to fire up OpenGL or other cumbersome API.

So I wrote a simple program which I called BurgerGFX, with 2 core functionalities: draw point and draw line. I find this to be quite enough for simple applications such as viewing a graph.

Setting up the drawing canvas, which I call burger, is simple: call create(width, height), which returns a pointer to the burger. Then simply call the draws, prints and cleans as needed.

<!-- more -->

Here's the code for your enjoyment.

<div class="highlight"><pre><code class="language-c">
/*
    File: burgergfx.c

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

#include
#include
#include

typedef struct
{
      int w,h;
      char* burger_matrix;
} burger;

/**
 *  @brief Create a new w x h burger
 *
 *  @param [in] w width
 *  @param [in] h height
 *  @return pointer to burger
 */
burger* create(int w, int h)
{
      burger* bgfx = malloc(sizeof(burger));
      bgfx->w = w;
      bgfx->h = h;
      bgfx->burger_matrix = malloc(sizeof(char)*w*h);
      int i=0;
      for (;i<w*h;i++) bgfx->burger_matrix[i] = '.';
      return bgfx;
}

/**
 *  @brief Get the appropriate cell from a normalized x coordinate
 *
 *  @param [in] b burger
 *  @param [in] x normalized coordinate
 *  @return cell index
 */
int get_norm_x(burger* b, double x)
{
      return (int) round(b->w*x);
}

/**
 *  @brief Get the appropriate cell from a normalized y coordinate
 *
 *  @param [in] b burger
 *  @param [in] y normalized coordinate
 *  @return cell index
 */
int get_norm_y(burger* b, double y)
{
      return (int) round(b->h*y);
}

/**
 *  @brief Fill the burger with whitespace
 *
 *  @param [in] b

 */
void clean_burger(burger* b)
{
      int i=0;
      for (;iw*b->h;i++) b->burger_matrix[i] = ' ';
}

/**
 *  @brief Put char in cell
 *
 *  @param [in] b  burger
 *  @param [in] dx normalized x position
 *  @param [in] dy normalized y position
 *  @param [in] c  char to be put
 */
void put_burger(burger* b, double dx, double dy, char c)
{
      int x = get_norm_x(b, dx);
      int y = get_norm_y(b, dy);
      b->burger_matrix[y+(x*b->w)] = c;
}

/**
 *  @brief Put char in cell
 *
 *  @param [in] b burger
 *  @param [in] x cell index
 *  @param [in] y cell index
 *  @param [in] c char to be put
 */
void put_burger_int(burger* b, int x, int y, char c)
{
      b->burger_matrix[y+(x*b->w)] = c;
}

/**
 *  @brief Print the current burger
 *
 *  @param [in] bgfx
 */
void print_burger(burger* bgfx)
{

      int i = 0, j = 0;
      printf("\n");
      for (;i<(bgfx->w/2)-2;i++) printf("  ");
      printf("Burger\n");
      for (i=0;ih;i++)
      {
            for (j=0;jw;j++)
            {
                  printf("%c ",bgfx->burger_matrix[i+(j*bgfx->w)]);
            }
            printf("\n");
      }
}

/**
 *  @brief Draw line from point 1 to point 2 on burger
 *
 *  @param [in] bgfx
 *  @param [in] dx1  point 1 normalized x coord
 *  @param [in] dy1  point 1 normalized y coord
 *  @param [in] dx2  point 2 normalized x coord
 *  @param [in] dy2  point 2 normalized y coord
 */
void put_line(burger* bgfx, double dx1, double dy1, double dx2, double dy2)
{
      int x1 = get_norm_x(bgfx, dx1);
      int y1 = get_norm_y(bgfx, dy1);
      int x2 = get_norm_x(bgfx, dx2);
      int y2 = get_norm_y(bgfx, dy2);

      int i = 0;

      float a = (float)(y2-y1)/(float)(x2-x1);

      if (x1<x2)
      {
            for (i=x1; i            {
                  int x = i - x1;
                  int y = (int) (a*x) + y1;
                  put_burger_int(bgfx, i, y, '.');
            }
      }
      else
      {
            for (i=x2; i<x1; i++)
            {
                  int x = i - x2;
                  int y = (int) (a*x) + (y1                  put_burger_int(bgfx, i, y, '.');
            }
      }
}
</code></pre></div>
