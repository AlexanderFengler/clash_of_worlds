# Read in arguments:
abc=None
cde=None

while [ ! $# -eq 0 ]
    do
        case "$1" in
            --abc | -a)
                abc=$2
                ;;
            --cde | -c)
                cde=$2
                ;;
        esac
        shift 2
    done

echo "abc: $abc"
echo "cde: $cde"