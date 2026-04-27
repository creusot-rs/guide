# WARNING: this messes with the creusot repository using `git checkout -f`, so make sure your work is saved.
# Build the dev version and the latest released version.
# For the dev version, add a header to Markdown pages of the guide that changed since the latest release
set -e
cd creusot
CURRENT=$(git rev-parse HEAD)
RELEASED=$(git describe --tags --abbrev=0)
for MDFILE in $(git diff --name-only $RELEASED guide/src|grep "\.md$"|grep -v "SUMMARY.md$") ; do
  FILE=${MDFILE##guide/src/}
  FILE=${FILE%%md}html
  cat - $MDFILE > $MDFILE.tmp << EOF
> [!IMPORTANT]
> This is the dev version of the Guide. There may be significant differences with the latest release.
> [See $RELEASED of this page.](https://guide.creusot.rs/$RELEASED/${FILE})

EOF
mv $MDFILE.tmp $MDFILE
done
mdbook build guide --dest-dir out/
git checkout -f $RELEASED
mdbook build guide --dest-dir out/$RELEASED