FROM alpine/git AS builder

WORKDIR /gaia
ARG GAIA_CORE_GIT_URL='https://github.com/OHDSI/GIS.git'
ARG GAIA_CORE_GIT_BRANCH='containerize'
RUN git clone --depth 1 -b ${GAIA_CORE_GIT_BRANCH} ${GAIA_CORE_GIT_URL} .

FROM postgis/postgis:16-3.5-alpine

# perhaps better as correctly named from another repo??
# COPY --from=builder /gaia/vocabularies/*.csv /csv/
COPY --from=builder /gaia/vocabularies/gis_vocabs_vocabulary_stage_v1.csv /csv/gis_vocabulary_fragment.csv
COPY --from=builder /gaia/vocabularies/gis_vocabs_concept_class_stage_v1.csv /csv/gis_concept_class_fragment.csv
COPY --from=builder /gaia/vocabularies/gis_vocabs_domain_stage_v1.csv /csv/gis_domain_fragment.csv
COPY --from=builder /gaia/vocabularies/gis_vocabs_concept_stage_v1.csv /csv/gis_concept_fragment.csv
COPY --from=builder /gaia/vocabularies/gis_vocabs_relationship_stage_v1.csv /csv/gis_relationship_fragment.csv
COPY --from=builder /gaia/vocabularies/gis_vocabs_concept_relationship_stage_v1.csv /csv/gis_concept_relationship_fragment.csv

# also perhaps better located in the correct repo and copied from builder
COPY ./init.sql /docker-entrypoint-initdb.d/
