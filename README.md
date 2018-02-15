# nitrcbot: Package that retrieves NITRC images
[![Travis build status](https://travis-ci.org/adigherman/nitrcbot.svg?branch=master)](https://travis-ci.org/adigherman/nitrcbot)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/j9r27opai5xl48cy/branch/master?svg=true)](https://ci.appveyor.com/adigherman/nitrcbot)
[![codecov](https://codecov.io/gh/adigherman/nitrcbot/branch/master/graph/badge.svg)](https://codecov.io/gh/adigherman/nitrcbot)

## About NITRC

Neuroimaging Informatics Tools and Resources Clearinghouse ([NITRC](https://www.nitrc.org)) is currently a free one-stop-shop collaboratory for science researchers that need resources such as neuroimaging analysis software, publicly available data sets, or computing power. 

NITRC scientific focus includes: PET/SPECT, CT, EEG/MEG, optical imaging, clinical neuroinformatics, computational neuroscience, and imaging genomics software tools, data, and computational resources.

NITRC database currently contains 14 projects, 6845 subjects, and 8285 imaging sessions.

ID    |    Name    |         Description          |  Access type
------|------------|------------------------------|-------------
fcon_1000|1000 Functional Connectomes|The 1000 Functional Connectomes Project.|Public project
ixi|IXI dataset|IXI (Information eXtraction from Images) dataset. 600 MR images from normal, healthy subjects.|Public project.
cs_schizbull08|CANDI Share: Schizophrenia Bulletin 2008|Version 1.1 of the CANDI Share Schizophrenia Bulletin 2008 data.|Public project.
parktdi|High-quality diffusion-weighted imaging of Parkinson's disease|Data for a set of 53 subjects in a cross-sectional Parkinson's disease (PD) study.|Public project.
studyforrest_rev003|Study Forrest rev003|Study Forrest rev00 3. http://studyforrest.org/ Supported by BMBF 01GQ1112 and NSF 1129855.|Public project.
ABIDE|ABIDE|Autism Brain Imaging Data Exchange.|Access required.
adhd_200|ADHD-200|The ADHD-200 sample from the 1000 Functional Connectomes project.|Access required.
beijing_enh|Beijing Enhanced|INDI Beijing Enhanced.|Access required.
beijing_eoec|Beijing Eyes Open Eyes Closed|INDI Beijing Eyes Open Eyes Closed Study.|Access required.
short_tr|Beijing Short TR|INDI Beijing Short TR Study.|Access required.
corr|Consortium for Reliability and Reproducibility (CoRR)|The goal of CoRR was to create an open science resource for the imaging community that facilitates the assessment of test-retest reliability and reproducibility.|Access required.
nki_rockland|INDI NKI/Rockland Sample||Access required.
kin|Kurtosis Imaging Network (KIN)|Kurtosis Imaging Network (KIN) is an open source database for normal healthy controls as well as various pathologies in an attempt to establish a standard range of kurtosis values within each population. This database of diffusional kurtosis images will also allow for quantitative comparisons between sites, vendors, and various protocol parameters. Finally, KIN will also help develop a strong collaborative network for researchers to troubleshoot current projects and create future projects.|Access required.
PING|Pediatric Imaging, Neurocognition, and Genetics (PING) Study|The Data Resource includes neurodevelopmental histories, information about developing mental and emotional functions, multimodal brain imaging data, and genotypes for well over 1000 children and adolescents between the ages of 3 and 20.|Access required.

## Accessing Data
In order to access the NITRC data, a user account is required. One can be requested [here](https://www.nitrc.org/account/register.php). Some of the projects are public and can be accessed right away, while some others will need an additional access request.

## Installing the nitrcbot package

You can install `nitrcbot` from github with:

``` {r}
# install.packages("devtools")
devtools::install_github("adigherman/nitrcbot")
```
## Setting the username and password

In the `nitrcbot` package, set_credentials will set the username and password:

``` {r}
set_credentials(username = "XXX", password = "YYY")
```
or they can be stored in `NITRC_WEB_USER` and `NITRC_WEB_PASS` [environment variables](https://stat.ethz.ch/R-manual/R-devel/library/base/html/EnvVar.html).

Once the username and password are set, `nitrcbot` functions can be used. To test the username and password, one can run `list_image_sets`, a simple function that will retrieve all available NITRC projects summary.

``` {r}
nitrc_sets <- nitrcbot::list_image_sets()
nitrc_sets_summary <- nitrc_sets[,c("ID","Name","Subjects")]
```

``` {r}
nitrc_sets_summary
                   ID                                                           Name Subjects
1                  kin                                       Kurtosis Imaging Network       81
2  studyforrest_rev003                                           Study Forrest rev003       20
3         nki_rockland                                       INDI NKI/Rockland Sample      207
4                 PING   Pediatric Imaging, Neurocognition, and Genetics (PING) Study        0
5                  ixi                                                    IXI dataset      584
6              parktdi High-quality diffusion-weighted imaging of Parkinson's disease       53
7       cs_schizbull08                       CANDI Share: Schizophrenia Bulletin 2008      103
8             short_tr                                               Beijing Short TR       28
9         beijing_eoec                                  Beijing Eyes Open Eyes Closed       48
10         beijing_enh                                               Beijing Enhanced      180
11               ABIDE                                                          ABIDE     1112
12                corr          Consortium for Reliability and Reproducibility (CoRR)     1386
13           fcon_1000                                    1000 Functional Connectomes     1288
14            adhd_200                                                       ADHD-200      973
```
The username and password are valid and we have a list of all 14 NITRC projects. If a project has 0 subjects (e.g. PING) this means we need to request access to the PING project through the NITRC website.

## Getting Data: Downloading a Directory of Data
As an example we will download a directory of images from the `ixi` project. The first step is to read the project data into a data.frame and for that we'll use the `read_nitrc_project` function.
``` {r}
ixi_project <- read_nitrc_project('ixi')
head(ixi_project)
               ID label project gender handedness      session_ID scan_ID   age
1 NITRC_IR_S05189     2     ixi female            NITRC_IR_E10452      PD  35.8
2 NITRC_IR_S05189     2     ixi female            NITRC_IR_E10452      T1  35.8
3 NITRC_IR_S05189     2     ixi female            NITRC_IR_E10452     MRA  35.8
4 NITRC_IR_S05189     2     ixi female            NITRC_IR_E10452     DTI  35.8
5 NITRC_IR_S05189     2     ixi female            NITRC_IR_E10452      T2  35.8
6 NITRC_IR_S05190    12     ixi   male            NITRC_IR_E10453      T1 38.78
```
We can subset the `ixi` subjects that are `male` and have `T1` imaging.
``` {r}
ixi_T1_males = ixi_project %>%
    filter(gender %in% "male") %>%
    filter(scan_ID %in% "T1") %>%
    select(ID, session_ID) %>%
    unique
head(ixi_T1_males)
```
``` {r}
               ID      session_ID
1 NITRC_IR_S05190 NITRC_IR_E10453
2 NITRC_IR_S05191 NITRC_IR_E10454
3 NITRC_IR_S05193 NITRC_IR_E10456
4 NITRC_IR_S05194 NITRC_IR_E10457
5 NITRC_IR_S05196 NITRC_IR_E10459
6 NITRC_IR_S05197 NITRC_IR_E10460
```
We can now download the full directory (individual files) of T1 data using `download_nitrc_dir` and providing the `session_ID` and `scan_type` arguments:
``` {r}
t1_res <- download_nitrc_dir("NITRC_IR_E10453", scan_type="T1")
t1_res$files
[1] "77390_IXI012-HH-1211-T1.nii.gz" "77391_qc_t.gif"                 "77391_qc.gif" 
```
If we'd rather download a zipped file containing the full directory, we need to specify `zipped = TRUE` as argument for the `download_nitrc_dir` function:
``` {r}
> download_nitrc_dir("NITRC_IR_E10453", scan_type="T1", zipped = TRUE)
[1] "/var/folders/kr/05bm5krj0r3fpwxfdmx4xthm0000gn/T//RtmpVWPpmG/NITRC_IR_E10453.zip"
```

## Getting Data: Downloading a Single File

We can also download a single file using `download_nitrc_file`. To identify the file URI, we'll use the `get_scan_resources` function:
``` {r}
r <- get_scan_resources('NITRC_IR_E10453')
> head(r$URI)
[1] "/data/experiments/NITRC_IR_E10453/scans/DTI/resources/77382/files/IXI012-HH-1211-DTI-00.nii.gz"
[2] "/data/experiments/NITRC_IR_E10453/scans/DTI/resources/77382/files/IXI012-HH-1211-DTI-01.nii.gz"
[3] "/data/experiments/NITRC_IR_E10453/scans/DTI/resources/77382/files/IXI012-HH-1211-DTI-02.nii.gz"
[4] "/data/experiments/NITRC_IR_E10453/scans/DTI/resources/77382/files/IXI012-HH-1211-DTI-03.nii.gz"
[5] "/data/experiments/NITRC_IR_E10453/scans/DTI/resources/77382/files/IXI012-HH-1211-DTI-04.nii.gz"
[6] "/data/experiments/NITRC_IR_E10453/scans/DTI/resources/77382/files/IXI012-HH-1211-DTI-05.nii.gz"
```
``` {r}
> download_nitrc_file("/data/experiments/NITRC_IR_E10453/scans/DTI/resources/77382/files/IXI012-HH-1211-DTI-05.nii.gz")
[1] "/var/folders/kr/05bm5krj0r3fpwxfdmx4xthm0000gn/T//RtmpVWPpmG/IXI012-HH-1211-DTI-05.nii.gz"
```
