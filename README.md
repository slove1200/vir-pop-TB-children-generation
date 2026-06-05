# Virtual pediatric population with tuberculosis

This repository contains the codebase for simulating virtual TB pediatric populations.
For more information, please check [Svensson et al. (*Clin Pharmacokinet*, 2018)](https://link.springer.com/article/10.1007/s40262-017-0577-6) and [Lin et al. (*Clin Pharmacol Ther*, 2025)](https://ascpt.onlinelibrary.wiley.com/doi/10.1002/cpt.3536).

## Workflow & File Descriptions

### (in the "LMS-fitting-parameters" directory) `LMS_approximations_refit.R`
Fits the LMS values for both genders and extracts the parameters of the LMS functions.
* **Inputs:** `male_LMS_values.csv`, `female_LMS_values.csv`

### `runWTsim.mod`
Simulates the virtual children population with a TB correction factor incorporated in NONMEM.
* **Customized:** Specify the age cut (in months) you’d like to simulate in **Line 26** of the .mod file.
* **Input:** `WT_base.csv`
* **Output:** `simtab_WT_15.tab`

### `vir-pop-children-LMS.R`
Sets up the cutoff for the higher end of body weight in the population and creates the time-varying body weight for the virtual population based on LMS approximation functions.
* **Dependencies:** Reads in `LMS_approximation.R` as a source function.

---

## Virtual population generation (TB children)

A virtual cohort of 40,000 pediatric TB patients was generated, featuring an equal gender distribution. Age was assigned using a uniform distribution across a range of 0 to <15 years. Body weight was derived from WHO growth standards for children aged 0–10 years [1] and NHANES data for those aged 11–15 years [2], with adjustments made for TB-related weight effects [3]. The simulation excluded neonates under 3 kg, preterm infants, and children more than 80 kg. The current WHO weight- and age-based MDR-TB dosing regimens were evaluated.

To account for the long treatment period for TB, child growth was taken into account by reassessing each subject's age and weight at monthly intervals. Patients were reassigned to the corresponding weight-age tiers, with dosages adjusted to reflect their current growth stage.

---

## References
* **[1]** [World Health Organization WHO child growth standards: length/ height-for-age, weight-for-age, weight-for-length, weight-for-height, and body mass index-for-age: methods and development (2006). <https://www.who.int/publications/i/item/924154693X>](https://www.who.int/publications/i/item/924154693X)
* **[2]** [Kuczmarski, R.J. et al. 2000 CDC growth charts for the United States: methods and development. Vital Health Stat. 11, 1–190 (2002).](https://www.cdc.gov/nchs/data/series/sr_11/sr11_246.pdf)
* **[3]** [Svensson, E.M., Yngman, G., Denti, P., McIlleron, H., Kjellsson, M.C. & Karlsson, M.O. Evidence-based design of fixed-dose combinations: principles and application to pediatric antituberculosis therapy. Clin. Pharmacokinet. 57, 591–599 (2018).](https://link.springer.com/article/10.1007/s40262-017-0577-6)