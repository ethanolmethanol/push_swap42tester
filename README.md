# push_swap42tester
---
## Foreword
This repository contains my very own tester for push_swap, the 42 project in which you are given a list of unsorted numbers to sort in the least amount of push/swap/rotate/reverse-rotate operations using two stacks.
It uses by default the provided checker_linux binary, but you can provide, for instance, your own checker (bonus part).
Also included is a visualizer I found in another repo which is easy to use and a great help to find sorting inefficiencies.
## Using the tester
- Copy the tester and checker in the diretory containing your push_swap executable file.
- With no argument, the tester performs tests on all permutations of 3 and 5 numbers, which respectively should yield less than 3 and 12 operations.
- With arguments, the syntax is as follows:
```./emistester.sh <a> <b> <c> (optional: custom checker)```
Where a-b is the range of numbers to shuffle and input in push_swap,
and c is the number of tests to perform.
Example : ```./emistester.sh 1 100 100 ./checker```
## Using the visualizer
- Copy the visualizer in the diretory containing your push_swap executable file.
- To visualize your sorting for random numbers from 1 to 100, run ```python3 python_visualizer.py `ruby -e "puts (1..100).to_a.shuffle.join(' ')"` ```
or
```python3 python_visualizer.py $(seq 1 100 | shuf | tr '\n' ' ')```
