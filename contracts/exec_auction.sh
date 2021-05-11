admin_alias=<YOUR_ALIAS>
buyer_alias=buyer

completium-cli set account $admin_alias
admin=`completium-cli show address $admin_alias`
completium-cli deploy nft.arl --init $admin --force
completium-cli call nft --entry mint --with "(24, $admin, \"ipfs://...\", $admin, 15, 100)" --force
nft=`completium-cli show address nft`
completium-cli deploy auction.arl --init "($admin, 24, $nft)" --force
completium-cli call auction --entry upforsale --with 10tz --force
completium-cli set account $buyer_alias
completium-cli call auction --entry bid --amount 12tz --force
# wait 3 minutes
sleep 180
completium-cli call auction --entry claim --force
