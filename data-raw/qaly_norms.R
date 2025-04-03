
mvh <- data.table(sex = c(rep("male", 8), rep("female", 8)),
                  age_low = c(0, 18, 25, 35, 45, 55, 65, 75),
                  age_high = c(17, 24, 34, 44, 54, 64, 74, 200),
                  qn = c(# male
                        c(0.94, 0.94, 0.93, 0.91, 0.84, 0.78, 0.78, 0.75),
                        # female
                        c(0.94, 0.94, 0.93, 0.91, 0.85, 0.81, 0.78, 0.71)),
                  name = "mvh")






temp <- tempfile()
download.file(url = "https://raw.githubusercontent.com/bitowaqr/shortfall/main/src%20manuscript/output/hrqol_co_ci_df.csv", temp)

vih_primary <- as.data.table(utils::read.csv(temp))


vih_primary[, age_low := as.numeric(substring(age5_str, 1, 2))]
vih_primary[, age_high := as.numeric(substring(age5_str, 4, 5))]
vih_primary[age_low == max(age_low), age_high := 200]
vih_primary[, qn := sub(" .*", "", m_ci)]
vih_primary[, c("age5_str", "m_ci", "n"):=NULL]
vih_primary[, name := "vih"]

yg <- vih_primary[age_low == min(age_low)]
yg[, age_high := age_low - 1]
yg[, age_low := 0]

vih_primary <- rbind(vih_primary, yg)


qaly_norms <- rbind(mvh, vih_primary) |>
  setcolorder(c("name", "sex", "age_low", "age_high", "qn")) |>
  setorder(name, age_low, sex)

qaly_norms[, age_low := as.numeric(age_low)]
qaly_norms[, age_high := as.numeric(age_high)]
qaly_norms[, qn := as.numeric(qn)]


usethis::use_data(qaly_norms, internal = TRUE, overwrite = TRUE)



