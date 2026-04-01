# r_lt_health returns correct value

    Code
      data.table(x = c(0:200))[, r := r_lt_health(x)]
    Output
               x      r
           <int>  <num>
        1:     0 0.0150
        2:     1 0.0150
        3:     2 0.0150
        4:     3 0.0150
        5:     4 0.0150
       ---             
      197:   196 0.0107
      198:   197 0.0107
      199:   198 0.0107
      200:   199 0.0107
      201:   200 0.0107

# r_lt_health_reduced returns correct value

    Code
      data.table(x = c(0:200))[, r := r_lt_health_reduced(x)]
    Output
               x      r
           <int>  <num>
        1:     0 0.0100
        2:     1 0.0100
        3:     2 0.0100
        4:     3 0.0100
        5:     4 0.0100
       ---             
      197:   196 0.0071
      198:   197 0.0071
      199:   198 0.0071
      200:   199 0.0071
      201:   200 0.0071

