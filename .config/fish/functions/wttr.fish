function wttr 
  if set -q argv[1]
    set location $argv[1]
  else
    set location "mclean-va"
  end

  # Parse language information, if not set then from current locale
  if set -q argv[2]
    set language $argv[2]
  else
    set language (string split "_" -- $LANG)[1]
  end

  curl -H "Accept-Language: $language" wttr.in/$location
end
