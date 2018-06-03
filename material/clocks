#!/bin/bash
#
# Author: LKJ
# Date: 2013/5/14
# Email: liungkejin@gmail.com
#

asciinumber=(
    '    .XEEEEb           ,:LHL          :LEEEEEG        .CNEEEEE8                bMNj       NHKKEEEEEX           1LEEE1    KEEEEEEEKNMHH       8EEEEEL.         cEEEEEO    '
    '   MEEEUXEEE8       jNEEEEE         EEEEHMEEEEU      EEEELLEEEEc             NEEEU      7EEEEEEEEEK        :EEEEEEN,    EEEEEEEEEEEEE     OEEEGC8EEEM      1EEELOLEEE3  '
    '  NEE.    OEEC      EY" MEE         OC      LEEc     :"      EEE            EEGEE3      8EN               MEEM.                  :EE.    1EEj     :EEO    1EE3     DEEc '
    ' ,EEj      EEE          HEE                  EEE             cEE:          EEU EEJ      NEC              EEE                     EEJ     EEE       EEE    EEN       KEE '
    ' HEE       jEE1         NEE                  EEE             EEE          EEM  EEJ      EE              LEE   ..                EEK      DEEj     :EE7   ,EE1       jEE '
    ' EEH        EEZ         KEE                 :EE1       .::jZEEG          EEU   EEJ     .EEEEEENC        EE77EEEEEEL            NEE        UEENj  bEE7    .EEX       :EE.'
    '.EEZ        EEM         KEE                 EEK        EEEEEEC         .EEc    EEC     :X3DGMEEEEU     3EEEED.".GEEE.         CEE.          EEEEEEE       EEEj     :EEE '
    ' EEZ        EEM         KEE               :EEK            "jNEEZ      :EE      EE7             MEEU    LEEb       EEE        .EE8         DEEL:.8EEEM      NEEENMEEEHEE '
    ' EEN       .EEG         KEE              bEEG                7EEM    jEEN738ODDEEM3b            EEE    MEE        8EE,       EEE         EEE      ,EEE      .bEEEEC XEE '
    ' LEE       3EE:         KEE            .EEE,                  EEE    LEEEEEEEEEEEEEE            XEE    8EE        cEE:      NEE         7EE1       jEE1            :EE: '
    ' .EEc      EEE          KEE           bEED                    EEE              EE1              EEE     EEX       EEE      3EE:         cEEc       7EEj           CEEG  '
    '  MEE7    NEE.          EEE         jEEK             C       EEE1              EEC     j      :EEE      CEEG     LEEj     .EEU           EEE:     .EEE          1EEEJ   '
    '   bEEEEEEEE.           EEE        NEEEEEEEEEEEE    bEEEEEEEEEE7               EEd    JEEEEEEEEEN        jEEEEEEEEE7     .EEE             KEEEEHEEEEL      8EEEEEEX     '
    '     DEEEL7             CGD        3GD3DOGGGGGUX     :DHEEEN8.                 bUd     7GNEEEMc            7LEEEX:       1XG                JHEEEM1        COLIN"       '
);

asciidot=(
    ' @@ '
    ' @@ '
);

len=${#asciinumber[@]};

#共有三个参数, 
#第一个是所要打印的数字, 
#第二个是之前打印的数字个数，
#第三个是之前打印的点的个数
function print_number {
    start=$(($1*17));
    start_y=$(($2*17+$3*4+$beg_y));

    for (( i = 0; i < len; i++ )); do
        echo -ne "\033[$((beg_x+i));${start_y}H\e[1;32m${asciinumber[$i]:$start:17}\e[0m";
    done
}

#print_dot有两个参数
#第一个参数是之前打印的数字个数
#第二个参数是之前打印的点的个数
function print_dot {
    local pt=$(($1*17+$2*4+beg_y));
    for (( j = 0; j < 2; j++ )); do
        echo -ne "\033[$((beg_x+j+3));${pt}H\e[1;32m${asciidot[$j]}\e[0m";
        echo -ne "\033[$((beg_x+j+10));${pt}H\e[1;32m${asciidot[$j]}\e[0m";
    done
}

function old_value {
    orows=`tput lines`; beg_x=$((orows/2-6)); 
    ocols=`tput cols`;  beg_y=$((ocols/2-54));

    ohur=$((10#`date +%H`));
    omin=$((10#`date +%M`));
    osec=$((10#`date +%S`));

    print_number $((ohur/10)) 0 0; print_number $((ohur%10)) 1 0;
    print_dot 2 0;
    print_number $((omin/10)) 2 1; print_number $((omin%10)) 3 1;
    print_dot 4 1;
    print_number $((osec/10)) 4 2; print_number $((osec%10)) 5 2;
}

function print_all {
    t_rows=`tput lines`; beg_x=$((t_rows/2-6));
    t_cols=`tput cols`;  beg_y=$((t_cols/2-54));

    if [[ $t_rows -ne $orows || $t_cols -ne $ocols ]]; then
        orows=$t_rows;
        ocols=$t_cols;
        check_win $orows $ocols;
        old_value;
    fi

    hur=$((10#`date +%H`));
    hft=$((hur/10)); hsd=$((hur%10));
    if [[ $ohft -ne $hft ]]; then
        print_number $hft 0 0;
        ohft=$hft;
    fi
    if [[ $ohsd -ne $hsd ]]; then
        print_number $hsd 1 0;
        ohsd=$hsd;
    fi

    min=$((10#`date +%M`));
    mft=$((min/10)); msd=$((min%10));
    if [[ $omft -ne $mft ]]; then
        print_number $mft 2 1;
        omft=$mft;
    fi
    if [[ $omsd -ne $msd ]]; then
        print_number $msd 3 1;
        omsd=$msd;
    fi

    sec=$((10#`date +%S`)); #出现(())bug的原因：date +%S < 10 的时候会有前置0
                    #所以((08/10))会出错,但是使用expr不会出现错误,let也会有此错误
                    #解决方法是$((10#08/10));
    sft=$((sec/10)); ssd=$((sec%10));
    if [[ $osft -ne $sft ]]; then
        print_number $sft 4 2;
        osft=$sft;
    fi
    if [[ $ossd -ne $ssd ]]; then
        print_number $ssd 5 2;
        ossd=$ssd;
    fi

}

function check_win {
    if [[ $1 -lt 14 || $2 -lt 110 ]]; then
        clear;
        echo -ne "\033[8;15;120t"; #change the window size
    fi
    clear; #若窗口改变则重新刷新
}

function INIT {
    tput smcup; #保存屏幕
    check_win `tput lines` `tput cols`;
    trap 'EXIT;' SIGINT; #将光标重新设置为白色
    tput civis; #设置光标不可见
    old_value;
}

function EXIT {
    tput cvvis; #使光标可见
    tput rmcup; #恢复屏幕
    exit 0;
}


INIT;
while true; do
    read -t 0.01 -n 1 anykey;
    if [[ $? -eq 0 ]]; then
        EXIT;
    fi
    print_all;
    sleep 0.3; 
done

exit 0;
