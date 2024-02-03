#!/bin/bash

git archive -o Remixed_Additions.zip --prefix='Remixed Additions/' HEAD
cp -f Remixed_Additions.zip ../NYRDS/common

