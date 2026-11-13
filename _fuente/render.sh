#!/bin/zsh
# Dibuja las imágenes del perfil desde piezas.html con Chrome sin ventana (2x).
# Uso: zsh _fuente/render.sh            (todas)
#      zsh _fuente/render.sh card:wave  (una)
set -e
cd "${0:A:h}"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
OUT=../assets
TMP=$(mktemp -d)
mkdir -p $OUT
typeset -A SIZE
SIZE=(banner 1280x460 sec 1280x200 card 620x500 skill 620x210 cta 1280x300)
PIECES=(banner sec:webs sec:software sec:skills sec:stack
  card:amante card:bulls card:thunder card:camiseros card:wave card:hamburgruesas
  card:gym card:placa card:caserita
  skill:web-con-concepto skill:carrusel-con-gancho skill:carrusel-en-movimiento skill:video-de-producto skill:web-en-linea
  cta)
[[ $# -gt 0 ]] && PIECES=($@)
for p in $PIECES; do
  kind=${p%%:*}; name=${p/:/-}
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=2 \
    --virtual-time-budget=4000 --window-size=${SIZE[$kind]/x/,} \
    --screenshot="$TMP/$name.png" "file://$PWD/piezas.html#$p" >/dev/null 2>&1
  if [[ $kind == card ]]; then
    cwebp -quiet -q 86 "$TMP/$name.png" -o "$OUT/$name.webp"
  else
    cp "$TMP/$name.png" "$OUT/$name.png"
  fi
  echo "ok $p"
done
rm -rf $TMP
