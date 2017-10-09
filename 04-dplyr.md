---
title: Manipulating and analyzing data with dplyr; Exporting data
author: Data Carpentry contributors
output:
  html_document:
    toc: yes
    toc_float: yes
---





------------

> ## Learning Objectives
>
> By the end of this lesson the learner will:
>
> * Recall the six data manipulation ‘verbs’ in the dplyr package and know what they do.
> * Select subsets of columns and filter rows in a data.frame according to a condition(s).
> * Employ the ‘pipe’ operator to link together a sequence of dplyr commands.
> * Employ the ‘mutate’ command to apply functions to existing columns and create new columns of data.
> * Export a data.frame to a .csv file.

------------

# Data Manipulation using dplyr

Bracket subsetting is handy, but it can be cumbersome and difficult to read,
especially for complicated operations. Enter `dplyr`. `dplyr` is a package for
making data manipulation easier.

Packages in R are basically sets of additional functions that let you do more
stuff. The functions we've been using so far, like `str()` or `data.frame()`,
come built into R; packages give you access to more of them. Before you use a
package for the first time you need to install it on your machine, and then you
should import it in every subsequent R session when you need it.


```r
install.packages("dplyr")
```

You might get asked to choose a CRAN mirror -- this is basically asking you to
choose a site to download the package from. The choice doesn't matter too much;
we recommend the RStudio mirror (`1: 0-Cloud`).


```r
library("dplyr")    ## load the package
```

## What is `dplyr`?

The package `dplyr` provides easy tools for the most common data manipulation
tasks. It is built to work directly with data frames. The thinking behind it was
largely inspired by the package `plyr` which has been in use for some time but
suffered from being slow in some cases.` dplyr` addresses this by porting much
of the computation to C++. An additional feature is the ability to work directly
with data stored in an external database. The benefits of doing this are
that the data can be managed natively in a relational database, queries can be
conducted on that database, and only the results of the query are returned.

This addresses a common problem with R in that all operations are conducted
in-memory and thus the amount of data you can work with is limited by available
memory. The database connections essentially remove that limitation in that you
can have a database of many 100s GB, conduct queries on it directly, and pull
back into R only what you need for analysis.

To learn more about `dplyr` after the workshop, you may want to check out this
[handy dplyr cheatsheet](http://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf).


## Selecting columns and filtering rows

To select columns of a data frame, use `select()`. The first argument
to this function is the data frame (`surveys`), and the subsequent
arguments are the columns to keep.


```r
select(surveys, plot_id, species_id, weight)
```

To choose rows, use `filter()`:


```r
filter(surveys, year == 1995)
```

```
##      record_id month day year plot_id species_id sex hindfoot_length
## 1        22314     6   7 1995       2         NL   M              34
## 2        22728     9  23 1995       2         NL   F              32
## 3        22899    10  28 1995       2         NL   F              32
## 4        23032    12   2 1995       2         NL   F              33
## 5        22003     1  11 1995       2         DM   M              37
## 6        22042     2   4 1995       2         DM   F              36
## 7        22044     2   4 1995       2         DM   M              37
##      weight            genus         species    taxa
## 1        NA          Neotoma        albigula  Rodent
## 2       165          Neotoma        albigula  Rodent
## 3       171          Neotoma        albigula  Rodent
## 4        NA          Neotoma        albigula  Rodent
## 5        41        Dipodomys        merriami  Rodent
## 6        45        Dipodomys        merriami  Rodent
## 7        46        Dipodomys        merriami  Rodent
##                      plot_type
## 1                      Control
## 2                      Control
## 3                      Control
## 4                      Control
## 5                      Control
## 6                      Control
## 7                      Control
##  [ reached getOption("max.print") -- omitted 1173 rows ]
```

## Pipes

But what if you wanted to select and filter at the same time? There are three
ways to do this: use intermediate steps, nested functions, or pipes.

With intermediate steps, you essentially create a temporary data frame and use
that as input to the next function. This can clutter up your workspace with lots
of objects. You can also nest functions (i.e. one function inside of another).
This is handy, but can be difficult to read if too many functions are nested as
things are evaluated from the inside out.

The last option, pipes, are a fairly recent addition to R. Pipes let you take
the output of one function and send it directly to the next, which is useful
when you need to do many things to the same data set.  Pipes in R look like
`%>%` and are made available via the `magrittr` package, installed automatically
with `dplyr`.


```r
surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)
```

```
##    species_id sex weight
## 1          PF   F      4
## 2          PF   F      4
## 3          PF   M      4
## 4          RM   F      4
## 5          RM   M      4
## 6          PF          4
## 7          PP   M      4
## 8          RM   M      4
## 9          RM   M      4
## 10         RM   M      4
## 11         PF   M      4
## 12         PF   F      4
## 13         RM   M      4
## 14         RM   M      4
## 15         RM   F      4
## 16         RM   M      4
## 17         RM   M      4
```

In the above, we use the pipe to send the `surveys` data set first through
`filter()` to keep rows where `weight` is less than 5, then through `select()`
to keep only the `species_id`, `sex`, and `weight` columns. Since `%>%` takes
the object on its left and passes it as the first argument to the function on
its right, we don't need to explicitly include it as an argument to the
`filter()` and `select()` functions anymore.

If we wanted to create a new object with this smaller version of the data, we
could do so by assigning it a new name:


```r
surveys_sml <- surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)

surveys_sml
```

```
##    species_id sex weight
## 1          PF   F      4
## 2          PF   F      4
## 3          PF   M      4
## 4          RM   F      4
## 5          RM   M      4
## 6          PF          4
## 7          PP   M      4
## 8          RM   M      4
## 9          RM   M      4
## 10         RM   M      4
## 11         PF   M      4
## 12         PF   F      4
## 13         RM   M      4
## 14         RM   M      4
## 15         RM   F      4
## 16         RM   M      4
## 17         RM   M      4
```

Note that the final data frame is the leftmost part of this expression.

> ### Challenge {.challenge}
>
>  Using pipes, subset the `survey` data to include individuals collected before
>  1995 and retain only the columns `year`, `sex`, and `weight`.

<details>

```r
## Answer
surveys %>%
    filter(year < 1995) %>%
    select(year, sex, weight)
```

```
##       year sex weight
## 1     1977   M     NA
## 2     1977   M     NA
## 3     1977         NA
## 4     1977         NA
## 5     1977         NA
## 6     1977         NA
## 7     1977         NA
## 8     1978         NA
## 9     1978   M    218
## 10    1978         NA
## 11    1978         NA
## 12    1978   M    204
## 13    1978   M    200
## 14    1978   M    199
## 15    1978   M    197
## 16    1978         NA
## 17    1978   M    218
## 18    1979   M    166
## 19    1979   M    184
## 20    1979   M    206
## 21    1979   F    274
## 22    1979   F    186
## 23    1980   F    184
## 24    1980   F     NA
## 25    1980   F     87
## 26    1980   F    174
## 27    1981   F    130
## 28    1981   M    208
## 29    1981   M    192
## 30    1982   M    206
## 31    1982   F    165
## 32    1982   M    202
## 33    1982   M    211
##  [ reached getOption("max.print") -- omitted 21453 rows ]
```
</details>

### Mutate

Frequently you'll want to create new columns based on the values in existing
columns, for example to do unit conversions, or find the ratio of values in two
columns. For this we'll use `mutate()`.

To create a new column of weight in kg:


```r
surveys %>%
  mutate(weight_kg = weight / 1000)
```

```
##       record_id month day year plot_id species_id sex hindfoot_length
## 1             1     7  16 1977       2         NL   M              32
## 2            72     8  19 1977       2         NL   M              31
## 3           224     9  13 1977       2         NL                  NA
## 4           266    10  16 1977       2         NL                  NA
## 5           349    11  12 1977       2         NL                  NA
## 6           363    11  12 1977       2         NL                  NA
## 7           435    12  10 1977       2         NL                  NA
##       weight            genus         species    taxa
## 1         NA          Neotoma        albigula  Rodent
## 2         NA          Neotoma        albigula  Rodent
## 3         NA          Neotoma        albigula  Rodent
## 4         NA          Neotoma        albigula  Rodent
## 5         NA          Neotoma        albigula  Rodent
## 6         NA          Neotoma        albigula  Rodent
## 7         NA          Neotoma        albigula  Rodent
##                       plot_type weight_kg
## 1                       Control        NA
## 2                       Control        NA
## 3                       Control        NA
## 4                       Control        NA
## 5                       Control        NA
## 6                       Control        NA
## 7                       Control        NA
##  [ reached getOption("max.print") -- omitted 34779 rows ]
```

If this runs off your screen and you just want to see the first few rows, you
can use a pipe to view the `head()` of the data. (Pipes work with non-dplyr
functions, too, as long as the `dplyr` or `magrittr` package is loaded).


```r
surveys %>%
  mutate(weight_kg = weight / 1000) %>%
  head
```

```
##   record_id month day year plot_id species_id sex hindfoot_length weight
## 1         1     7  16 1977       2         NL   M              32     NA
## 2        72     8  19 1977       2         NL   M              31     NA
## 3       224     9  13 1977       2         NL                  NA     NA
## 4       266    10  16 1977       2         NL                  NA     NA
## 5       349    11  12 1977       2         NL                  NA     NA
## 6       363    11  12 1977       2         NL                  NA     NA
##     genus  species   taxa plot_type weight_kg
## 1 Neotoma albigula Rodent   Control        NA
## 2 Neotoma albigula Rodent   Control        NA
## 3 Neotoma albigula Rodent   Control        NA
## 4 Neotoma albigula Rodent   Control        NA
## 5 Neotoma albigula Rodent   Control        NA
## 6 Neotoma albigula Rodent   Control        NA
```

Note that we don't include parentheses at the end of our call to `head()` above.
When piping into a function with no additional arguments, you can call the
function with or without parentheses (e.g. `head` or `head()`).

The first few rows of the output are full of `NA`s, so if we wanted to remove
those we could insert a `filter()` in the chain:


```r
surveys %>%
  filter(!is.na(weight)) %>%
  mutate(weight_kg = weight / 1000) %>%
  head
```

```
##   record_id month day year plot_id species_id sex hindfoot_length weight
## 1       588     2  18 1978       2         NL   M              NA    218
## 2       845     5   6 1978       2         NL   M              32    204
## 3       990     6   9 1978       2         NL   M              NA    200
## 4      1164     8   5 1978       2         NL   M              34    199
## 5      1261     9   4 1978       2         NL   M              32    197
## 6      1453    11   5 1978       2         NL   M              NA    218
##     genus  species   taxa plot_type weight_kg
## 1 Neotoma albigula Rodent   Control     0.218
## 2 Neotoma albigula Rodent   Control     0.204
## 3 Neotoma albigula Rodent   Control     0.200
## 4 Neotoma albigula Rodent   Control     0.199
## 5 Neotoma albigula Rodent   Control     0.197
## 6 Neotoma albigula Rodent   Control     0.218
```

`is.na()` is a function that determines whether something is an `NA`. The `!`
symbol negates the result, so we're asking for everything that *is not* an `NA`.

> ### Challenge {.challenge}
>
>  Create a new data frame from the `survey` data that meets the following
>  criteria: contains only the `species_id` column and a new column called
>  `hindfoot_half` containing values that are half the `hindfoot_length` values.
>  In this `hindfoot_half` column, there are no `NA`s and all values are less
>  than 30.
>
>  **Hint**: think about how the commands should be ordered to produce this data frame!


<details>

```r
## Answer
surveys_hindfoot_half <- surveys %>%
    filter(!is.na(hindfoot_length)) %>%
    mutate(hindfoot_half = hindfoot_length / 2) %>%
    filter(hindfoot_half < 30) %>%
    select(species_id, hindfoot_half)
```
</details>


### Split-apply-combine data analysis and the summarize function

Many data analysis tasks can be approached using the *split-apply-combine*
paradigm: split the data into groups, apply some analysis to each group, and
then combine the results. `dplyr` makes this very easy through the use of the
`group_by()` function.


#### The `summarize()` function

`group_by()` is often used together with `summarize()`, which collapses each
group into a single-row summary of that group.  `group_by()` takes as arguments
the column names that contain the **categorical** variables for which you want
to calculate the summary statistics. So to view the mean `weight` by sex:


```r
surveys %>%
  group_by(sex) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE))
```

```
## # A tibble: 3 x 2
##      sex mean_weight
##   <fctr>       <dbl>
## 1           64.74257
## 2      F    42.17055
## 3      M    42.99538
```

You can also group by multiple columns:


```r
surveys %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE))
```

```
## # A tibble: 92 x 3
## # Groups:   sex [?]
##       sex species_id mean_weight
##    <fctr>     <fctr>       <dbl>
##  1                AB         NaN
##  2                AH         NaN
##  3                AS         NaN
##  4                BA         NaN
##  5                CB         NaN
##  6                CM         NaN
##  7                CQ         NaN
##  8                CS         NaN
##  9                CT         NaN
## 10                CU         NaN
## # ... with 82 more rows
```

When grouping both by `sex` and `species_id`, the first rows are for individuals
that escaped before their sex could be determined and weighted. You may notice
that the last column does not contain `NA` but `NaN` (which refers to "Not a
Number"). To avoid this, we can remove the missing values for weight before we
attempt to calculate the summary statistics on weight. Because the missing
values are removed, we can omit `na.rm = TRUE` when computing the mean:


```r
surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight))
```

```
## # A tibble: 64 x 3
## # Groups:   sex [?]
##       sex species_id mean_weight
##    <fctr>     <fctr>       <dbl>
##  1                DM    38.28571
##  2                DO    50.66667
##  3                DS   120.00000
##  4                NL   167.68750
##  5                OL    29.00000
##  6                OT    21.20000
##  7                PB    30.60000
##  8                PE    17.66667
##  9                PF     6.00000
## 10                PI    18.00000
## # ... with 54 more rows
```

You may also have noticed that the output from these calls doesn't run off the
screen anymore. That's because `dplyr` has changed our `data.frame` to a
`tbl_df`. The `tbl` data structure is very similar to a data frame; for our
purposes the only difference is that, in addition to displaying the data type
of each column under its name, it only prints the first few rows of data and
only as many columns as fit on one screen. If you want to display more data, you
use the `print()` function at the end of your chain with the argument `n`
specifying the number of rows to display:


```r
surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight)) %>%
  print(n = 15)
```

```
## # A tibble: 64 x 3
## # Groups:   sex [?]
##       sex species_id mean_weight
##    <fctr>     <fctr>       <dbl>
##  1                DM    38.28571
##  2                DO    50.66667
##  3                DS   120.00000
##  4                NL   167.68750
##  5                OL    29.00000
##  6                OT    21.20000
##  7                PB    30.60000
##  8                PE    17.66667
##  9                PF     6.00000
## 10                PI    18.00000
## 11                PL    25.00000
## 12                PM    20.25000
## 13                PP    14.60000
## 14                RM    11.08333
## 15                SF    40.50000
## # ... with 49 more rows
```

Once the data are grouped, you can also summarize multiple variables at the same
time (and not necessarily on the same variable). For instance, we could add a
column indicating the minimum weight for each species for each sex:


```r
surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight),
            min_weight = min(weight))
```

```
## # A tibble: 64 x 4
## # Groups:   sex [?]
##       sex species_id mean_weight min_weight
##    <fctr>     <fctr>       <dbl>      <dbl>
##  1                DM    38.28571         24
##  2                DO    50.66667         44
##  3                DS   120.00000         78
##  4                NL   167.68750         83
##  5                OL    29.00000         21
##  6                OT    21.20000         18
##  7                PB    30.60000         20
##  8                PE    17.66667         17
##  9                PF     6.00000          4
## 10                PI    18.00000         18
## # ... with 54 more rows
```


#### Tallying

When working with data, it is also common to want to know the number of
observations found for each factor or combination of factors. For this, `dplyr`
provides `tally()`. For example, if we wanted to group by sex and find the
number of rows of data for each sex, we would do:


```r
surveys %>%
  group_by(sex) %>%
  tally
```

```
## # A tibble: 3 x 2
##      sex     n
##   <fctr> <int>
## 1         1748
## 2      F 15690
## 3      M 17348
```

Here, `tally()` is the action applied to the groups created by `group_by()` and
counts the total number of records for each category.

> ### Challenge {.challenge}
>
> 1. How many individuals were caught in each `plot_type` surveyed?
>
> 2. Use `group_by()` and `summarize()` to find the mean, min, and max hindfoot
> length for each species (using `species_id`).
>
> 3. What was the heaviest animal measured in each year? Return the
> columns `year`, `genus`, `species_id`, and `weight`. Optional: order
> by descending year using `arrange` and `desc`.
>
> 4. You saw above how to count the number of individuals of each `sex` using a
> combination of `group_by()` and `tally()`. How could you get the same result
> using `group_by()` and `summarize()`? Hint: see `?n`.


<details>

```r
## Answer 1
surveys %>%
    group_by(plot_type) %>%
    tally
```

```
## # A tibble: 5 x 2
##                   plot_type     n
##                      <fctr> <int>
## 1                   Control 15611
## 2  Long-term Krat Exclosure  5118
## 3          Rodent Exclosure  4233
## 4 Short-term Krat Exclosure  5906
## 5         Spectab exclosure  3918
```

```r
## Answer 2
surveys %>%
    filter(!is.na(hindfoot_length)) %>%
    group_by(species_id) %>%
    summarize(
        mean_hindfoot_length = mean(hindfoot_length),
        min_hindfoot_length = min(hindfoot_length),
        max_hindfoot_length = max(hindfoot_length)
    )
```

```
## # A tibble: 25 x 4
##    species_id mean_hindfoot_length min_hindfoot_length max_hindfoot_length
##        <fctr>                <dbl>               <dbl>               <dbl>
##  1         AH             33.00000                  31                  35
##  2         BA             13.00000                   6                  16
##  3         DM             35.98235                  16                  50
##  4         DO             35.60755                  26                  64
##  5         DS             49.94887                  39                  58
##  6         NL             32.29423                  21                  70
##  7         OL             20.53261                  12                  39
##  8         OT             20.26741                  13                  50
##  9         OX             19.12500                  13                  21
## 10         PB             26.11592                   2                  47
## # ... with 15 more rows
```

```r
## Answer 3
surveys %>%
    filter(!is.na(weight)) %>%
    group_by(year) %>%
    filter(weight == max(weight)) %>%
    select(year, genus, species, weight) %>%
    arrange(desc(year))
```

```
## # A tibble: 27 x 4
## # Groups:   year [26]
##     year   genus  species weight
##    <int>  <fctr>   <fctr>  <int>
##  1  2002 Neotoma albigula    248
##  2  2001 Neotoma albigula    280
##  3  2000 Neotoma albigula    265
##  4  1999 Neotoma albigula    227
##  5  1998 Neotoma albigula    238
##  6  1997 Neotoma albigula    231
##  7  1996 Neotoma albigula    185
##  8  1995 Neotoma albigula    171
##  9  1994 Neotoma albigula    226
## 10  1993 Neotoma albigula    233
## # ... with 17 more rows
```

```r
## Answer 4
surveys %>%
  group_by(sex) %>%
  summarize(n = n())
```

```
## # A tibble: 3 x 2
##      sex     n
##   <fctr> <int>
## 1         1748
## 2      F 15690
## 3      M 17348
```
</details>


# Exporting data

Now that you have learned how to use `dplyr` to extract information from or
summarize your raw data, you may want to export these new datasets to share
them with your collaborators or for archival.

Similar to the `read.csv()` function used for reading CSVs into R, there is a
`write.csv()` function that generates CSV files from data frames.

Before using `write.csv()`, we are going to create a new folder, `data_output`,
in our working directory that will store this generated dataset. We don't want
to write generated datasets in the same directory as our raw data. It's good
practice to keep them separate. The `data` folder should only contain the raw,
unaltered data, and should be left alone to make sure we don't delete or modify
it. In contrast, our script will generate the contents of the `data_output`
directory, so even if the files it contains are deleted, we can always
re-generate them.

In preparation for our next lesson on plotting, we are going to prepare a
cleaned up version of the dataset that doesn't include any missing data.

Let's start by removing observations for which the `species_id` is missing. In
this dataset, the missing species are represented by an empty string and not an
`NA`. Let's also remove observations for which `weight` and the
`hindfoot_length` are missing. This dataset should also only contain
observations of animals for which the sex has been determined:



```r
surveys_complete <- surveys %>%
  filter(species_id != "",         # remove missing species_id
         !is.na(weight),           # remove missing weight
         !is.na(hindfoot_length),  # remove missing hindfoot_length
         sex != "")                # remove missing sex
```

Because we are interested in plotting how species abundances have changed
through time, we are also going to remove observations for rare species (i.e.,
that have been observed less than 50 times). We will do this in two steps: first
we are going to create a dataset that counts how often each species has been
observed, and filter out the rare species; then, we will extract only the
observations for these more common species:


```r
## Extract the most common species_id
species_counts <- surveys_complete %>%
  group_by(species_id) %>%
  tally %>%
  filter(n >= 50)

## Only keep the most common species
surveys_complete <- surveys_complete %>%
  filter(species_id %in% species_counts$species_id)
```

To make sure that everyone has the same dataset, check that
`surveys_complete` has 30463 rows and 13
columns by typing `dim(surveys_complete)`.

Now that our dataset is ready, we can save it as a CSV file in our `data_output`
folder. By default, `write.csv()` includes a column with row names (in our case
the names are just the row numbers), so we need to add `row.names = FALSE` so
they are not included:


```r
write.csv(surveys_complete, file = "data_output/surveys_complete.csv",
          row.names=FALSE)
```


