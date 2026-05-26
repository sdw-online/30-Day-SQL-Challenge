<p align="center">
  <img src="../assets/banners/day-19-recursive-ctes.svg" width="800" alt="Day 19 - Recursive CTEs">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Day-19_of_30-blue" alt="Day 19">
  <img src="https://img.shields.io/badge/Week-3-purple" alt="Week 3">
  <img src="https://img.shields.io/badge/Difficulty-Advanced-orange" alt="Advanced">
</p>

# Day 19 - Recursive CTEs

[<< Day 18: Normalisation & Denormalisation](../day-18/) | [Day 20: Data Modelling (Star Schema) >>](../day-20/)

---

## What You'll Learn

- How recursive CTEs walk through tree-shaped data one level at a time
- The two-part structure: anchor member (starting rows) and recursive member (next level)
- How to traverse org charts, category trees, folder hierarchies, and bill of materials
- How to add safety limits and detect cycles to prevent infinite recursion

---

## Key Concepts

- **Recursive CTE structure:** An anchor member (starting rows) connected to a recursive member (next level) by UNION ALL - the recursive member references the CTE's own name

---

## Where To Next?

<p align="center">
  <img src="../assets/banners/day-19-where-next.svg" width="900" alt="Where To Next?">
</p>

---

<p align="center">
  <a href="../day-18/">&#9664; Day 18: Normalisation & Denormalisation</a> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="../day-20/">Day 20: Data Modelling (Star Schema) &#9654;</a>
</p>
