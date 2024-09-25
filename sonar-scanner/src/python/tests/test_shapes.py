
# test_shapes.py -- tests for shapes.py
#
# Copyright (c) 2010, A. G. Smith
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


import unittest
import shapes

class TestShapes(unittest.TestCase):

    def setUp(self):
        pass

    def test_shape_init(self):
        shapes.Shape()
    
    def test_polygon_init(self):
        shapes.Polygon()

    def test_triangle_init(self):
        shapes.Triangle()

    def test_triangle_init(self):
        # failing test example
        b = 4
        h = 10
        t = shapes.Triangle(base=b, height=h)
        self.assertEqual(t.area(), (b*h)/2) 
    
    def test_quadrilateral_init(self):
        shapes.Quadrilateral()
    
    def test_parallelogram_init(self):
        shapes.Parallelogram()

    def test_parallelogram_area(self):
        b = 4
        h = 10
        p = shapes.Parallelogram(base=b, height=h)
        self.assertEqual(p.area(), b*h)

    def test_square_init(self):
        shapes.Square()

    def test_rectangle_init(self):
        shapes.Rectangle()