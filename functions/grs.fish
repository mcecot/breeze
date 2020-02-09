function grs
    git reset --
end

__breeze_variables

function __git_reset -a var
    set toplevel (git rev-parse --show-toplevel)

    # is numeric 
    if [ "$var" -eq "$var" ] 2>/dev/null
        # number
        set myarg $arr[$var]

        # -- (hyphen hyphen) compare
        set hyphen (printf "%b" (printf '%s%x' '\x' 45))
        if [ "$myarg" = "$hyphen$hyphen" ] 2>/dev/null
            set myarg './'$myarg 
        end

        git reset $toplevel/$myarg
    else
        # not a number
        git reset $toplevel/$var
    end
end

function __grs
    # number
    set res (string split "-" -- (string trim $argv))
    set first $res[1]
    set length (count $res)
    set last ""

    # >
    if [ $length -gt 1 ]
        set last $res[2]
    # >
    else
        # just one
        __git_reset $res
        return
    end

    # last exists
    if [ $last != '' ]
        set arr_length (count $arr)

        # clamp as array length
        if [ $arr_length -lt $last ]
          set last $arr_length 
        end

        # first < last
        if [ $first -lt $last ]
          for i in (seq $first 1 $last)
              __git_reset $i
          end
        else
          echo 'Argument is not valid.'
        end
    else
        __git_reset $first
    end
end

function grs
    # space like, `ga 1 2 3`
    set res (string split " " -- (string trim $argv))
    set length (count $res)

    # only one
    if [ $length -eq 0 ]
        __grs $argv
        return
    end

    for i in $res
        #echo $i
        __grs $i
    end
end
