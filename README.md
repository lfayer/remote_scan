# Remote vulnerability scanner

Simple script that uses Syft (https://github.com/anchore/syft) and Grype (https://github.com/anchore/grype) to run inventory of dependencies on remote servers, download it and run grype to understand vulnerabilities.  The script will insall syft and grype (if you don't have them) upload syft to each server in the list, run it, download results and run grype to show vulnerabilities.

For either Perl or bash script do the following:

Steps:
1. Set `$root_dir` and `$install_dir` variables to where this repo is and where you want binaries installed respectively
2. List out servers you want to scan in `@servers` array
3. Run `scan.pl` or `scan.bach`.  If you don't have syft and grype installed it'll install it for you

Results of grype from each server will be available in `grype_output/` folder.  From there, you can run analysis on individual server or across servers.  For example, you can `grep --with-filename log4j grype_output/*` to check for log4j zero-day CVE.
