context("cleaning the records")

# shorter delay to speed tests
old_delay <- getOption("aRxiv_delay")
options(aRxiv_delay=0.5)

# do this only if not on CRAN
on_cran <- Sys.getenv("NOT_CRAN")!="true"
if(!on_cran) {
    # count papers on 1997-01-01
    query <- "submittedDate:[199701010000 TO 199701012359]"

    # ignore search_info attribute and class
    expect_equal(omit_attr(arxiv_count(query)), 20)

    # do raw search to test parsing
    query_url <- "http://export.arxiv.org/api/query"
    delay_if_necessary()

    z <- httr::GET(query_url, query=list(search_query=query,
                                         start=0, max_results=20,
                                         sort_by="submitted"))
    z <- get_entries(result2list(z))

    # force a particular order
    id <- sapply(z, "[[", "id")
    exp_id <- c("http://arxiv.org/abs/gr-qc/9701001v1", "http://arxiv.org/abs/gr-qc/9701002v1",
                "http://arxiv.org/abs/hep-th/9705206v3", "http://arxiv.org/abs/astro-ph/9701001v1",
                "http://arxiv.org/abs/hep-th/9704137v2", "http://arxiv.org/abs/hep-th/9703045v3",
                "http://arxiv.org/abs/cond-mat/9705215v1", "http://arxiv.org/abs/q-alg/9701001v1",
                "http://arxiv.org/abs/cond-mat/9701002v3", "http://arxiv.org/abs/hep-th/9701002v1",
                "http://arxiv.org/abs/hep-th/9706029v1", "http://arxiv.org/abs/cs/9701102v1",
                "http://arxiv.org/abs/gr-qc/9701003v2", "http://arxiv.org/abs/q-alg/9701002v2",
                "http://arxiv.org/abs/astro-ph/9701002v1", "http://arxiv.org/abs/cs/9701101v1",
                "http://arxiv.org/abs/physics/9701001v1", "http://arxiv.org/abs/cond-mat/9701001v2",
                "http://arxiv.org/abs/quant-ph/9701001v1", "http://arxiv.org/abs/hep-th/9702183v2")

    z <- z[match(exp_id, id)]
}

test_that("clean_authors works right", {
    skip_on_cran()

    cleaned_auth <- clean_authors(z[[4]])
    expected_result <- list(names="Stefanie Komossa|Hartmut Schulz",
                            affiliations="MPE Garching, Ruhr-Univ. Bochum|Ruhr-Univ. Bochum")
    expect_equal(cleaned_auth, expected_result)

    cleaned_auth <- clean_authors(z[[2]])
    expected_result <- list(names="T. P. Singh|Louis Witten", affiliations="")
    expect_equal(cleaned_auth, expected_result)

    cleaned_auth <- clean_authors(z[[20]])
    expected_result <- list(names="Z. Bajnok",
                            affiliations="")
    expect_equal(cleaned_auth, expected_result)

})

test_that("clean_links works right", {
    skip_on_cran()

    cleaned_links <- clean_links(z[[1]])
    expected_result <- list(link_abstract="http://arxiv.org/abs/astro-ph/9603156v3",
                            link_pdf="http://arxiv.org/pdf/astro-ph/9603156v3",
                            link_doi="http://dx.doi.org/10.1086/304018")
#    expect_equal(cleaned_links, expected_result)


    cleaned_links <- clean_links(z[[2]])
    expected_result <- list(link_abstract="http://arxiv.org/abs/astro-ph/9612225v2",
                            link_pdf="http://arxiv.org/pdf/astro-ph/9612225v2",
                            link_doi="")
#    expect_equal(cleaned_links, expected_result)

    # manuscript with multiple DOI links
    delay_if_necessary()
    zz <- httr::GET(query_url, query=list(id_list="1206.1585v3",
                                          start=0, max_results=1))
    zz <- get_entries(result2list(zz))

    cleaned_links <- clean_links(zz[[1]])
    expected_result <- list(link_abstract="http://arxiv.org/abs/1206.1585v3",
                            link_pdf="http://arxiv.org/pdf/1206.1585v3",
                            link_doi="http://dx.doi.org/10.1112/jlms/jdt036|http://dx.doi.org/10.1112/jlms/jdu001")
#    expect_equal(cleaned_links, expected_result)

})


test_that("clean_categories works right", {
    skip_on_cran()

    cleaned_categories <- clean_categories(z[[1]])
    expected_result <- "gr-qc"
    expect_equal(cleaned_categories, expected_result)

    cleaned_categories <- clean_categories(z[[5]])
    expected_result <- "hep-th"
    expect_equal(cleaned_categories, expected_result)

    cleaned_categories <- clean_categories(z[[7]])
    expected_result <- "cond-mat.stat-mech|cond-mat.dis-nn"
    expect_equal(cleaned_categories, expected_result)

    # manuscript with 5 categories
    delay_if_necessary()
    zz <- httr::GET(query_url, query=list(id_list="1303.5613v1",
                                          start=0, max_results=1))
    zz <- get_entries(result2list(zz))

    cleaned_categories <- clean_categories(zz[[1]])
    expected_result <- "cs.SI|cs.LG|math.ST|physics.soc-ph|stat.ML"
    expect_equal(cleaned_categories, expected_result)

})

test_that("clean_record works right", {
    skip_on_cran()

    clean_record <- clean_record(z[[1]])
    expected_result <-  c(id = "gr-qc/9701001v1",
                          submitted = "1997-01-01 03:07:48",
                          updated = "2006-09-25 18:53:29",
                          title = "Gravitational Waves in Brans-Dicke Theory : Analysis by Test Particles around a Kerr Black Hole",
                          abstract = paste("  Analyzing test particles falling into a Kerr black hole, we study gravitational waves",
                                           "in Brans-Dicke theory of gravity. First we consider a test particle plunging with a",
                                           "constant azimuthal angle into a rotating black hole and calculate the waveform and",
                                           "emitted energy of both scalar and tensor modes of gravitational radiation. We find",
                                           "that the waveform as well as the energy of the scalar gravitational waves weakly",
                                           "depends on the rotation parameter of black hole $a$ and on the azimuthal angle.\n",
                                           " Secondly, using a model of a non-spherical dust shell of test particles falling into",
                                           "a Kerr black hole, we study when the scalar modes dominate. When a black hole is",
                                           "rotating, the tensor modes do not vanish even for a ``spherically symmetric\" shell,",
                                           "instead a slightly oblate shell minimizes their energy but with non-zero finite value,",
                                           "which depends on Kerr parameter $a$. As a result, we find that the scalar modes dominate",
                                           "only for highly spherical collapse, but they never exceed the tensor modes unless the",
                                           "Brans-Dicke parameter $ω_{BD} \\lsim 750 $ for $a/M=0.99$ or unless $ω_{BD} \\lsim 20,000",
                                           "$ for $a/M=0.5$, where $M$ is mass of black hole.\n  We conclude that the scalar",
                                           "gravitational waves with $ω_{BD} \\lsim$ several thousands do not dominate except",
                                           "for very limited situations (observation from the face-on direction of a test particle",
                                           "falling into a Schwarzschild black hole or highly spherical dust shell collapse into a",
                                           "Kerr black hole). Therefore observation of polarization is also required when we",
                                           "determine the theory of gravity by the observation of gravitational waves."),
                          authors = "Motoyuki Saijo|Hisa-aki Shinkai|Kei-ichi Maeda",
                          affiliations = "",
                          link_abstract = "",
                          link_pdf = "",
                          link_doi = "",
                          comment = "24 pages, revtex, 18 figures are attached with ps files",
                          journal_ref = "Phys.Rev. D56 (1997) 785-797",
                          doi = "10.1103/PhysRevD.56.785",
                          primary_category = "gr-qc",
                          categories = "gr-qc")
    expect_equal(clean_record, expected_result)

    clean_record <- clean_record(z[[3]])
    expected_result <- c(id = "hep-th/9705206v3",
                         submitted = "1997-01-01 13:37:51",
                         updated = "2009-10-30 20:39:48",
                         title = "A Global Uniqueness Theorem for Stationary Black Holes",
                         abstract = paste("  A global uniqueness theorem for stationary black holes is proved as a",
                                          "direct consequence of the Topological Censorship Theorem and the topological",
                                          "classification of compact, simply connected four-manifolds."),
                         authors = "Gabor Etesi",
                         affiliations = "",
                         link_abstract = "",
                         link_pdf = "",
                         link_doi = "",
                         comment = "9 pages, latex, journal reference added",
                         journal_ref = "Commun.Math.Phys. 195 (1998) 691-697",
                         doi = "10.1007/s002200050408",
                         primary_category = "hep-th",
                         categories = "hep-th|gr-qc")
    expect_equal(clean_record, expected_result)


})

test_that("listresult2df works right", {
    skip_on_cran()

    zdf <- listresult2df(z)

    # authors (with a bit of pain over UTF-8)
    authors <- c("Motoyuki Saijo|Hisa-aki Shinkai|Kei-ichi Maeda", "T. P. Singh|Louis Witten",
                 "Gabor Etesi", "Stefanie Komossa|Hartmut Schulz",
                 "L. K. Balázs|J. Balog|P. Forgács|N. Mohammedi|L. Palla|J. Schnittger",
                 "J. Balog|L. Fehér|L. Palla", "C. De Dominicis|I. Kondor|T. Temesvari",
                 "S. Majid", "Osamu Tsuchiya", "Stefan Mashkevich", "Gábor Etesi",
                 "S. Wermter|V. Weber", "Masaru Siino", "S. Majid", "Re'em Sari|Tsvi Piran",
                 "D. R. Wilson|T. R. Martinez", "D. Zilbersher|M. Gedalin", "David R. Nelson|Ady Stern",
                 "Charles H. Bennett|Ethan Bernstein|Gilles Brassard|Umesh Vazirani",
                 "Z. Bajnok")
    expect_equal(zdf$authors, authors)

    # date updated
    updated <- c("2006-09-25 18:53:29", "2009-10-30 20:24:57", "2009-10-30 20:39:48",
                 "2016-08-30 17:06:18", "2009-10-30 20:39:04", "2009-10-30 20:38:16",
                 "2008-02-03 01:13:08", "2008-02-03 01:14:45", "2009-10-30 20:14:54",
                 "2005-09-17 14:53:57", "2016-09-06 16:54:37", "2009-09-25 02:47:25",
                 "2016-08-24 21:08:56", "2008-02-03 01:10:16", "2016-08-30 17:06:20",
                 "2009-09-25 02:47:25", "2009-10-30 20:45:31", "2016-08-31 14:31:34",
                 "2020-03-26 00:02:41", "2009-10-30 20:38:06")
    expect_equal(zdf$updated, updated)

    # date submitted
    submitted <- c("1997-01-01 03:07:48", "1997-01-01 10:51:29", "1997-01-01 13:37:51",
                   "1997-01-01 11:21:47", "1997-01-01 11:35:55", "1997-01-01 12:56:51",
                   "1997-01-01 07:42:16", "1997-01-01 01:21:36", "1997-01-01 10:12:51",
                   "1997-01-01 01:11:55", "1997-01-01 09:57:00", "1997-01-01 00:00:00",
                   "1997-01-01 11:57:02", "1997-01-01 01:22:02", "1997-01-01 07:03:28",
                   "1997-01-01 00:00:00", "1997-01-01 07:40:56", "1997-01-01 08:05:39",
                   "1997-01-01 13:55:07", "1997-01-01 10:54:15")
    expect_equal(zdf$submitted, submitted)

    # title
    title <- c("Gravitational Waves in Brans-Dicke Theory : Analysis by Test Particles around a Kerr Black Hole",
               "Cosmic censorship and spherical gravitational collapse with tangential pressure",
               "A Global Uniqueness Theorem for Stationary Black Holes",
               "Interpretation of the emission line spectra of Seyfert 2 galaxies by multi-component photoionization models",
               "Quantum equivalence of sigma models related by non Abelian Duality Transformations",
               "Coadjoint orbits of the Virasoro algebra and the global Liouville equation",
               "Beyond the Sherrington-Kirkpatrick Model", "Quantum Geometry and the Planck Scale",
               "Boundary S matrices for the open Hubbard chain with boundary fields",
               "Comment on ``Additional analytically exact solutions for three-anyons'' and ``Fermion Ground State of Three Particles in a Harmonic Potential Well and Its Anyon Interpolation''",
               "Spontaneous Symmetry Breaking in SO(3) Gauge Theory to Discrete Subgroups",
               "SCREEN: Learning a Flat Syntactic and Semantic Spoken Language Analysis Using Artificial Neural Networks",
               "Topology of Event Horizon", "Quantum Double for QuasiHopf Algebras",
               "Variability in GRBs - A Clue", "Improved Heterogeneous Distance Functions",
               "Pick-up ion dynamics at the structured quasi-perpendicular shock",
               "Polymer Winding Numbers and Quantum Mechanics", "Strengths and Weaknesses of Quantum Computing",
               "On the free field realization of $WBC_n$ algebras")
    expect_equal(zdf$title, title)

    # affiliations
    affil <- c("", "", "", "MPE Garching, Ruhr-Univ. Bochum|Ruhr-Univ. Bochum",
               "", "", "", "", "", "ITP, Kiev", "", "", "", "",
               "Hebrew University, Jerusalem, Israel|Hebrew University, Jerusalem, Israel",
               "", "", "Harvard|Weizmann", "", "")
    expect_equal(zdf$affiliations, affil)

    # primary_category
    primecat <- c("gr-qc", "gr-qc", "hep-th", "astro-ph", "hep-th", "hep-th",
                  "cond-mat.stat-mech", "math.QA", "cond-mat.stat-mech", "hep-th",
                  "hep-th", "cs.AI", "gr-qc", "math.QA", "astro-ph", "cs.AI", "physics.space-ph",
                  "cond-mat.stat-mech", "quant-ph", "hep-th")
    expect_equal(zdf$primary_category, primecat)

    # categories
    cats <- c("gr-qc", "gr-qc", "hep-th|gr-qc", "astro-ph", "hep-th", "hep-th",
              "cond-mat.stat-mech|cond-mat.dis-nn", "math.QA", "cond-mat.stat-mech|hep-th",
              "hep-th", "hep-th", "cs.AI", "gr-qc", "math.QA", "astro-ph",
              "cs.AI", "physics.space-ph", "cond-mat.stat-mech", "quant-ph",
              "hep-th")
    expect_equal(zdf$categories, cats)

})



# reset delay
options(aRxiv_delay=old_delay)
