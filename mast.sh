#!/bin/bash


rand_range() {
    #return a random number between $1 $2
    echo $((($RANDOM % ($2 - $1)) + $1))
}

generate_secret_code() {
    #$1 is the length of the ouput sequence

    #this will output a string containing a random number sequence 
    #containing values from 1 to $1
    local code=""
    for i in $(seq 1 $1)
    do
        code="$code$(rand_range 1 $1)"
    done

    echo $code
}



display_difficulty() {
    echo "entrez la taille du nombre a deviner :"
}



is_sequence_valid() {
    #$1 is the diffuculty level
    #$2 is the sequence to validate
    local valid=1

    if [[ ${#2} -ne $1 ]]; then
        valid=0
    fi

    for i in $(seq 0 $((${#1}-1))); do
        if [[ ${2:i:1} -lt 1 ]] || [[ ${2:i:1} -gt $1 ]]; then
            valid=0
        fi
    done

    echo $valid

}

oneplayer_matsermind() {
    display_difficulty
    read nb_size


    local secret=($(generate_secret_code $nb_size))
    local nb_try=5
    local user_try=""
    local bien_place=0
    local mal_place=0

    local winned=0
    
    local i=0
    while [[ $i -lt $nb_try ]]; do

        echo "il vous reste $(($nb_try-$i)) essais !!!"
        echo "entrer une sequence de $nb_size chiffres: "
        
        while [[ true ]]; do
            read user_try
            if [[ $(is_sequence_valid $nb_size $user_try) -eq 1 ]]; then
                break
            fi
            echo "entrez une sequence valid : "
        done
        

        bien_place=$(compte_bienplace $user_try $secret)
        mal_place=$(compte_malplace $user_try $secret)

        if [ $bien_place -eq $nb_size ]; then
            winned=1
            break
        else
            echo "bien placé: $bien_place | mal placé: $mal_place"
            i=$(($i+1));
        fi

    done 

    if [ $winned -eq 1 ]; then
        echo "bien joué! c'était la combinaison."
    else 
        echo "aie bien essayé mais c'est raté... la combinaison etait:  $secret"
    fi
}

versus_mastermind() {
    display_difficulty
    read nb_size

    local namep1=""
    local namep2=""
    
    echo "Joueur 1, entrez un nom :"
    read namep1
    echo "Joueur 2, entrez un nom :"
    read namep2

    local names=($namep1 $namep2)

    local secretp1=""
    local secretp2=""

    echo "${names[0]} entrez votre code secret: "
    
    read secretp1
    while [[ $(is_sequence_valid $nb_size $secretp1) -eq 0 ]]; do
        echo "entrez une sequence valid :"
        read secretp1
    done
    clear 

    echo "${names[1]} entrez votre code secret: "

    read secretp2
    while [[ $(is_sequence_valid $nb_size $secretp2) -eq 0 ]]; do
        echo "entrez une sequence valid :"
        read secretp2
    done
    clear

    local secrets=($secretp1 $secretp2)

    local bp=0
    local mp=0

    local user_try=""

    local current_turn=0
    local next_turn=0

    local running=1
    local winner=-1

    while [[ $running -eq 1 ]]; do


        next_turn=$((($current_turn+1)%2))

        echo "${names[$current_turn]} entrez une sequence de $nb_size chiffres:  "
        read user_try
        while [[ $(is_sequence_valid $nb_size $user_try) -eq 0 ]]; do
            echo "entrez une sequence valid :"
            read user_try
        done
        bp=$(compte_bienplace $user_try ${secrets[$next_turn]})
        mp=$(compte_malplace $user_try  ${secrets[$next_turn]})

        if [ $bp -eq $nb_size ]; then
            echo "bien joué a ${names[$winner]} !"
            if [ $winner -ne -1 ]; then
                break
            fi

            winner=$current_turn
            echo "${names[$next_turn]} voulez vous continuer a jouer ? (1 oui, 0 non): "
            local ans=0
            read ans
            if [[ $ans -eq 0 ]]; then
                break
            fi
            current_turn=$next_turn
            continue
        fi
        echo "bien placé: $bp | mal placé: $mp"

        if [[ $winner -eq -1 ]]; then
            current_turn=$next_turn
        fi
    done
}


nplayer_mastermind() {
    display_difficulty
    read nb_size


    local secret=($(generate_secret_code $nb_size))
    local nb_try=5
    local nb_player=$1
    local user_try=""
    local bp=0
    local mp=0

    local winner=-1
    local current_turn=0
    local finish_player=""
    local i=0
    while [[  $i -ne $nb_player ]]; do

        if [[ $finish_player =~ $current_turn ]]; then
            current_turn=$((($current_turn+1)%$nb_player))
            continue
        fi
        echo "Joueur $current_turn entrez une sequence de $nb_size chiffres: "
        
        while [[ true ]]; do
            read user_try
            if [[ $(is_sequence_valid $nb_size $user_try) -eq 1 ]]; then
                break
            fi
            echo "entrez une sequence valid : "
        done
        

        bp=$(compte_bienplace $user_try $secret)
        mp=$(compte_malplace $user_try $secret)

        if [ $bp -eq $nb_size ]; then
            echo "bien joué a joueur $current_turn !"

            winner=$current_turn
            finish_player+=$winner
            i=$(($i+1))
            echo "voulez vous continuer a jouer ? (1 oui, 0 non): "
            local ans=0
            read ans
            if [[ $ans -eq 0 ]]; then
                break
            fi
            current_turn=$((($current_turn+1)%$nb_player))
            continue
        fi
        echo "bien placé: $bp | mal placé: $mp"
        current_turn=$((($current_turn+1)%$nb_player))

    done 
 
}

compte_bienplace() {
    #$1 first sequence 
    #$2 second sequence
    local nbbien=0
    for i in $(seq 0 $((${#1}-1)))
    do
        if [[ ${1:i:1} -eq ${2:i:1} ]]; then
            
            nbbien=$(($nbbien+1))
        fi
    done

    echo $nbbien
}

compte_malplace() {
    #$1 first sequence 
    #$2 second sequence

    #create a copy of the strings to compare
    local cp1=$1
    local cp2=$2

    #initialise a counter
    local malplace=0

    #in order to find the number of misplaced values
    #we first occult the well placed ones here we substitute
    #there value with 0 as 0 is not a valid input for a sequence [1-n]
    for i in $(seq 0 $((${#cp1}-1)))
    do

        if [[ ${cp1:i:1} -eq ${cp2:i:1} ]]; then
            cp1="${cp1:0:i}0${cp1:i+1}"
            cp2="${cp2:0:i}0${cp2:i+1}"
        fi
    done

    #then we can start counting the actual misplaced values in the sequence
    #we basicaly go through each value and find if it as an occurence in the 
    #second sequence if it does we occult the first occurence of the value
    #and increment the counter  
    for i in $(seq 0 $((${#cp1}-1)))
    do
        if [[ ${cp1:i:1} != 0 ]]; then 

            for j in $(seq 0 $((${#cp2}-1)))
            do
                if [[ ${cp1:i:1} -eq ${cp2:j:1} ]]; then
                    cp2="${cp2:0:j}0${cp2:j+1}"
                    malplace=$(($malplace + 1))
                    break
                fi


            done
        fi
    done


    echo $malplace
}



main (){
    clear

    echo "Mode 1 joueur (0), mode versus (1) ou mode N joueurs (N) :"
    read mode

    if [[ $mode -eq 0 ]]; then
        oneplayer_matsermind
    elif [[ $mode -eq 1 ]]; then
        versus_mastermind
    else
        nplayer_mastermind $mode
    fi
}

while [[ true ]]; do
    main
    echo "voulez vous jouer a nouveau ? (1 oui, 0 non) :"
    read ans
    if [[ $ans -eq 0 ]]; then
        break
    fi
done 