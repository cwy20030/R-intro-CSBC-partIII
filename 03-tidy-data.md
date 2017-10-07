---
title: "Introduction to dplyr"
author: "Mark Dunning"
output:
  html_document:
    toc: yes
    toc_float: yes
---


# Overview of this section

- tidy data
    + what it means
    + how to create it
- **`select`** and **`mutate`** verbs in dplyr
- advice for cleaning strings and dates

![](images/tolstoy.jpg)

![](images/hadley.jpg)

> Like families, tidy datasets are all alike but every messy dataset is messy in its own way - (Hadley Wickham)

http://vimeo.com/33727555

http://vita.had.co.nz/papers/tidy-data.pdf

# Tidy Data

Tidy data are important because they are an entry point for the *analysis cycle* we will describe during the course.

![](images/data-cycle.png)

As we saw, our data, and especially data we might find out "in the wild", may need "cleaning"" before we can use it. We will discuss how to clean our data for analysis. However, there are steps you can take to make sure your data are tidy and organised before importing into R.

- [Karl Broman's tutorial on Data Organisation](http://kbroman.org/dataorg/)
- ["Data Carpentry" workshop](http://lgatto.github.io/2016-05-16-CAM/)

![](images/oh-the-horror.png)


## The data frame

The data frame object in R allows us to work with "tabular" data, like we might be used to dealing with in Excel, where our data can be thought of having rows and columns. The values in each column have to all be of the same type (i.e. all numbers or all text).

![](https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/Petal-sepal.jpg/226px-Petal-sepal.jpg)

The `iris` data frame is a [classic dataset](https://en.wikipedia.org/wiki/Iris_flower_data_set) that is built into R. To load these data, we tidy the variable name `iris` (notice no quotation marks) in brackets. This dataset is also a good example of data in the tidy form.

N.B. As we will see later, we tend to read datasets into R using `read.csv`, `read.delim` or similar functions.


```r
iris
```

```
##     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
## 1            5.1         3.5          1.4         0.2     setosa
## 2            4.9         3.0          1.4         0.2     setosa
## 3            4.7         3.2          1.3         0.2     setosa
## 4            4.6         3.1          1.5         0.2     setosa
## 5            5.0         3.6          1.4         0.2     setosa
## 6            5.4         3.9          1.7         0.4     setosa
## 7            4.6         3.4          1.4         0.3     setosa
## 8            5.0         3.4          1.5         0.2     setosa
## 9            4.4         2.9          1.4         0.2     setosa
## 10           4.9         3.1          1.5         0.1     setosa
## 11           5.4         3.7          1.5         0.2     setosa
## 12           4.8         3.4          1.6         0.2     setosa
## 13           4.8         3.0          1.4         0.1     setosa
## 14           4.3         3.0          1.1         0.1     setosa
## 15           5.8         4.0          1.2         0.2     setosa
## 16           5.7         4.4          1.5         0.4     setosa
## 17           5.4         3.9          1.3         0.4     setosa
## 18           5.1         3.5          1.4         0.3     setosa
## 19           5.7         3.8          1.7         0.3     setosa
## 20           5.1         3.8          1.5         0.3     setosa
##  [ reached getOption("max.print") -- omitted 130 rows ]
```

The `View` function will create a tab in RStudio that we can use to browse the data.


```r
View(iris)
```

The following will create a boxplot of the values in `Sepal.Length` column categorised into the different values of `Species`. Such a plot allows us to look for differences in mean between different groups, and also assess the variability of the data.


```r
boxplot(iris$Sepal.Length~iris$Species)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png)


An *analysis of variance* (ANOVA) analysis can also tell us if the differences between the groups are statistically significant


```r
mod <- aov(iris$Petal.Length~iris$Species)
anova(mod)
```

```
## Analysis of Variance Table
## 
## Response: iris$Petal.Length
##               Df Sum Sq Mean Sq F value    Pr(>F)    
## iris$Species   2 437.10 218.551  1180.2 < 2.2e-16 ***
## Residuals    147  27.22   0.185                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

## Example (from tidyr paper)

Consider the following....

Name          | treatmenta | treatmentb
------------- | -----------|-----------
John Smith    |    -       |    2
Jane Doe      |    16      |    11 
Mary Johnson  |    3       |    1


Data in this format are quite familiar to us, but not easily-interpret able by the computer. We need to think of the dataset in terms of *variables* and *values*. In this example dataset we have *18* values and *3* variables

1. Person (John, Jane or Mary)
2. Treatment (A or B)
3. "Result"

The guiding principles:

- Each column is a variable
- Each row is an observation
- Each type of observational unit forms a table

The tidy form of this data thus becomes;

Name          | Treatment  | Result
------------- | -----------|-----------
John Smith    |    a       |    -
Jane Doe      |    a       |    16 
Mary Johnson  |    a       |    3
John Smith    |    b       |    2
Jane Doe      |    b       |    11
Mary Johnson  |    b       |    1

We can read these data from the file `tidyr-example.txt`


```r
untidy <- read.delim("./data/tidyr-example.txt")
untidy
```

```
##           Name treatmenta treatmentb
## 1   John Smith          -          2
## 2     Jane Doe         16         11
## 3 Mary Johnson          3          1
```


## Using tidyr to tidy a dataset

`gather` is a function in the `tidyr` package that can collapse multiple columns into key-value pairs. 

- similar to `stack` in base R
- or `melt` in the `reshape` / `reshape2` packages

The arguments to `gather` are;

- the data frame you want to manipulate
- the name of the *key* column you want to create
- the name of the *value* column you want to create
- the *names* of the columns in the data frame that are to be collapsed
    + note you don't need "" to define the column names
        


```r
library(tidyr)
gather(untidy, Treatment, Result, c(treatmenta,treatmentb))
```

```
##           Name  Treatment Result
## 1   John Smith treatmenta      -
## 2     Jane Doe treatmenta     16
## 3 Mary Johnson treatmenta      3
## 4   John Smith treatmentb      2
## 5     Jane Doe treatmentb     11
## 6 Mary Johnson treatmentb      1
```

(*Ideally, the `Treatment` column should just be `a` or `b`, but we'll see how to change this later-on*)

When specifying columns, an alternative is to ignore some column names


```r
gather(untidy, Treatment, Result, -Name)
```

```
##           Name  Treatment Result
## 1   John Smith treatmenta      -
## 2     Jane Doe treatmenta     16
## 3 Mary Johnson treatmenta      3
## 4   John Smith treatmentb      2
## 5     Jane Doe treatmentb     11
## 6 Mary Johnson treatmentb      1
```

Can also specify column index


```r
gather(untidy, Treatment, Result, 2:3)
```

```
##           Name  Treatment Result
## 1   John Smith treatmenta      -
## 2     Jane Doe treatmenta     16
## 3 Mary Johnson treatmenta      3
## 4   John Smith treatmentb      2
## 5     Jane Doe treatmentb     11
## 6 Mary Johnson treatmentb      1
```

Note that after all these operations, the original data frame (`untidy`) is unaltered

  - we need to create a new variable to save the result
  - you should never work directly on the raw data


```r
untidy
```

```
##           Name treatmenta treatmentb
## 1   John Smith          -          2
## 2     Jane Doe         16         11
## 3 Mary Johnson          3          1
```

```r
tidy <- gather(untidy, Treatment, Result, c(treatmenta,treatmentb))
```

******

## Exercise: Simulated clinical data

Lets read some typical data from a clinical trial.

- Each patient was given a number of different treatments; Placebo, and two different drugs
    + Two replicates of each
- Some kind of measurement was performed to assess the effect of the drug
- Overall question is the effect of the treatment 


```r
messyData <- read.delim("./data/clinicalData.txt")
messyData
```

```
##      Subject Placebo.1 Placebo.2 Drug1.1 Drug1.2 Drug2.1 Drug2.2
## 1   Patient1     49.84     53.79   48.42   48.37   40.80   38.28
## 2   Patient2     46.75     49.77   49.65   41.62   39.14   41.89
## 3   Patient3     48.70     48.11   40.49   49.15   40.32   35.10
## 4   Patient4     51.68     48.14   38.27   41.10   40.74   41.15
## 5   Patient5     48.91     48.30   43.10   39.37   43.29   34.86
## 6   Patient6     53.54     44.71   47.50   42.88   39.48   35.60
## 7   Patient7     53.56     46.99   49.24   46.42   37.40   38.77
## 8   Patient8     46.15     43.23   47.31   38.32   43.99   33.75
## 9   Patient9     50.52     56.24   43.36   48.63   41.61   34.38
## 10 Patient10     46.97     44.76   44.86   50.07   39.01   36.22
```

- What variables and observations do we have?
- What might a 'tidy' version of the dataset look like?
- Can you make the following boxplot to visualise the effect of the different treatments?

![](images/tidy-boxplot.png)

<details>


```r
tidyData <- gather(messyData, key = Treatment, value = Value,-Subject)
boxplot(tidyData$Value~tidyData$Treatment)
```
</details>

******

## Other useful functions in 'tidyr'

`tidyr` has a few more useful functions that we can demonstrate on the `tidyData` object you should have just created

- `spread` has the opposite effect to `gather` and will translate tidy data back into human-readable form
    + arguments are the *Key* and *Value* columns in the tidy data frame


```r
spread(tidyData, key = Treatment,value=Value)
```

```
## Error in spread(tidyData, key = Treatment, value = Value): object 'tidyData' not found
```

- `separate` can be used to split column names that are comprised by two different parts with a common separating character. e.g. `Drug1.1`, `Drug1.2` etc.
    + it should be able to guess that a `.` character is being used to join the two different parts of the name together
    + we can explicitly say the separator being used. Apart from the `.` in our example other common values are `-`, `_`, `:`.


```r
separate(tidyData, "Treatment",into=c("Treatment","Replicate"))
```

```
## Error in separate(tidyData, "Treatment", into = c("Treatment", "Replicate")): object 'tidyData' not found
```
