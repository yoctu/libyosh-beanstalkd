function beanstalkd::value::checker ()
{
    for value in "$@"
    do
        if [[ -z "${!value}" ]]
        then
            http::send::status 500
            echo "BEANSTALKD ERROR: No ${value} set!"
            exit
        fi
    done
}

function beanstalkd::put ()
{
    local _tube="$1" priority="$2" delay="$3" ttr="$4" data="$5"

    # check if all values are set
    beanstalkd::value::checker priority delay ttr data _tube

    # get custom byte 
    bytes="${#data}"


    beanstalk-client.sh -H "${BEANSTALKD['host']}" -P "${BEANSTALKD['port']}" -t "$_tube" \
        put "$priority" "$delay" "$ttr" "$bytes" "$data"

}

function beanstalkd::peekReady ()
{
    local _tube="$1"    

    # check if values are set
    beanstalkd::value::checker _tube

    beanstalk-client.sh -H "${BEANSTALKD['host']}" -P "${BEANSTALKD['port']}" -t "$_tube" \
        peek-ready
}

function beanstalkd::buried ()
{
    local _tube="$1" _jobid="$2"

    # check if values are set
    beanstalkd::value::checker _tube _jobid="2"

    beanstalk-client.sh -H "${BEANSTALKD['host']}" -P "${BEANSTALKD['port']}" -t "$_tube" \
        bury "$_jobid"
}


function beanstalkd::delete ()
{
    local _tube="$1" jobid="$2"

    # check if values are set
    beanstalkd::value::checker _tube jobid

    beanstalk-client.sh -H "${BEANSTALKD['host']}" -P "${BEANSTALKD['port']}" -t "$_tube" \
        delete "$_jobid"
}

function beanstalkd::watch ()
{
    local _tube="$1"

    # check if values are set
    beanstalkt-value-checker _tube

    beanstalk-client.sh -H "${BEANSTALKD['host']}" -P "${BEANSTALKD['port']}" -t "$_tube" \
        watch    
}

function beanstalkd::listTubes ()
{
    beanstalk-client.sh -H "${BEANSTALKD['host']}" -P "${BEANSTALKD['port']}" \
        list-tubes
}

function beanstalkd::stats ()
{
    beanstalk-client.sh -H "${BEANSTALKD['host']}" -P "${BEANSTALKD['port']}" \
        stats
}


