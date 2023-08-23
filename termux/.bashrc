alias addalias="vim ~/.bashrc"
alias addshortcut="cd ~/.shortcuts"
alias req="pip install -r requirements.txt"
alias pyfiles="cd ~/storage/shared/python"
alias src="source ~/.bashrc"
alias streak="cd ~/storage/shared/python/github-streak; bash increment_counter.sh"


function lst() {
	files=("$PWD"/*)
	echo "1) ../"

	if [[ $(basename -- "${files[0]}") == "*" && ${#files[@]} -eq 1 ]]
	then
		files=()
	else
		for i in ${!files[@]}; do
			fileName=$(basename -- "${files[$i]}")
			echo "$((i+2))) $fileName"
		done
	fi

	read -p "Choose file/directory (press ENTER to choose CWD): " fileChosen

	re="^[0-9]+$"
	
	# If input is null, stay in current directory
	if [ -z "$fileChosen" ]
	then
		echo -e "\nYou chose the current directory\n"
	# If input is 1, move up a directory
	elif [ $fileChosen -eq 1 ]
	then
		cd ../
		echo -e "\nYou travelled up a directory\n"
	elif [[ $fileChosen =~ $re && $fileChosen -gt 1 && $fileChosen -le $((${#files[@]}+1)) ]]
	then
		# Check if choice is a directory
		if [ -d "${files[((fileChosen-=2))]}" ]
		then
			cd "${files[((fileChosen))]}"
		# The user chose a file
		else
			vim "${files[((fileChosen))]}"
		fi
		echo -e "\nYou chose '$(basename -- "${files[fileChosen]}")'\n"
	else
		echo -e "\nInput has to be a number from 1-$((${#files[@]}+1))\n"
	fi
}


function ex() {
	files=("$PWD"/*)
	exfiles=()
	for i in ${!files[@]}; do                                    fileName=$(basename -- "${files[$i]}")
		if [[ $fileName == *.py || $fileName == *.sh ]]
		then
			exfiles[${#exfiles[@]}]=$fileName
		fi
	done

	for i in ${!exfiles[@]}; do
		fileNumber=$i
		echo "$((fileNumber+=1))) "${exfiles[$i]}""
	done

	if [[ ${#exfiles[@]} -eq 0 ]]
	then
		echo -e "\nNo executable files found\n"
		return
	fi

	read -p "Choose file to execute: " fileChosen

	re="^[0-9]+$"

	if [ -z "$fileChosen" ]
        then
                echo -e "\nAborting execution\n"
	elif [[ $fileChosen =~ $re && $fileChosen -gt 1 && $fileChosen -le $((${#exfiles[@]})) ]]
	then
		echo -e "\nExecuting '$(basename -- "${exfiles[((fileChosen-=1))]}")'\n"
		if [[ "${exfiles[((fileChosen-=1))]}" == *.py ]]
		then
			python "${exfiles[$fileChosen]}"
		elif [[ "${exfiles[$fileChosen]}" == *.sh ]]
		then
			bash "${exfiles[$fileChosen]}"
		fi
	else
		echo -e "\nInput has to be a number from 1-$((${#exfiles[@]}))\n"
	fi
}

function info() {
	echo "Files: $(ls | wc -l)"
	
	lines=0
	for file in ${PWD[@]}/*; do
		if [ -f "$file" ]
		then
			((lines+=$(wc -l "$file" | awk {'print $1'})))
		fi
	done

	echo "Lines: $lines"
}


function clone() {
	git clone https://github.com/alexlostorto/$1.git
}

function safe {
	git config --global --add safe.directory /storage/emulated/0/python/$1
}


PS1='\w\$ '
