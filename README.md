# TSP_Haskell

Travelling salesman problem using functional programming (Haskell)

---

## Task analysis

Program has to get such input:
- 2 numbers. First one represents how many cities traveller has to visit and the second one - how many roads are there
- Names of cities in seperate lines
- 2 cities with a number. 2 cities represent the road and the number is the cost to use that road
- Input has to end with two zeros

With this input, program has to calculate the cheapest path to visit all listed cities or output "impossible" if there is no such path

## Test samples

Here are 3 tests, to show how this program is working. In one of them, the program had to find, that the induced subgraph is connected and the other two are not connected.

### First test

#### Input

        3 3
        Picadilly
        Victoria
        Queensway
        Picadilly Victoria 2
        Queensway Victoria 10
        Queensway Picadilly 20
        Picadilly
        4 2
        Picadilly
        Victoria
        Queensway
        Temple
        Picadilly Victoria 2
        Temple Queensway 100
        Temple
        0 0

#### Output

        12
        "Impossible"

### Second test

#### Input

        5 4
        Alytus
        Kaunas
        Palanga
        Klaipėda
        Vilnius
        Alytus Kaunas 2
        Alytus Klaipėda 3
        Klaipėda Vilnius 15
        Vilnius Palanga 7
        Kaunas
        0 0

#### Output

        27

### Third test

#### Input

        5 3
        Alytus
        Kaunas
        Palanga
        Klaipėda
        Vilnius
        Alytus Kaunas 15
        Kaunas Palanga 45
        Alytus Klaipėda 4
        Klaipėda
        0 0

#### Output

        "Impossible"
