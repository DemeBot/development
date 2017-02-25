# Enable extened patterns for bash file mtaching
shopt -s extglob

# For each dotenv file
for file in *.env; do
    # Check if the file is a .secret file, or in other words is not a template file
    if [[ $file != .secret.* ]];
    then
        echo "INFO: '$file' is a template."
        # Check for corresponding secret file
        if [[ ! -f .secret.${file} ]];
        then
            echo "WARN: no corresponding secret file for '$file'. "

            echo "INFO: creating '.secret.$file'"
            cp $file .secret.${file}

            echo "INFO: stripping leading comment line in '.secret.$file'"
            sed -i 's/^..//' .secret.${file}

            # Setup dotenv file
            # For each line which is not a comment
            for line_raw in $(grep "^[^#]" .secret.${file}); do

                # Get the variable name by stripping the '=' and everything after
                line_key=$(sed 's/\=.*//' <<< $line_raw)

                # Request for user input
                echo "SET ${line_key} to:"
                read line_value

                # Replace the varibale with the new value
                sed -i "s/$line_raw/${line_key}=${line_value}/" .secret.${file}
            done

            echo "INFO: Done setting up '.secret.$file'"
        else
            echo "INFO: '$file' has already been initialized"
            # Check for new variables
        fi
    fi
done