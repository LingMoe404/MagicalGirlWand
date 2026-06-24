# MagicalGirlWand锛氱嫭绔?CmdPal Fork 璁捐

## 鐘舵€?
- 鏃ユ湡锛?026-06-24
- 鐘舵€侊細宸茬敱鐢ㄦ埛鎵瑰噯
- 涓婃父浠撳簱锛歚microsoft/PowerToys`
- 璧峰涓婃父鎻愪氦锛歚80f2b9b07d56b2a8d27d73663e9c79751df81595`
- 宸ヤ綔鍒嗘敮锛歚cmdpal-standalone`

## 鑳屾櫙

MagicalGirlWand 灏嗕粠鍘熸湁鐨勭嫭绔?WinUI 鍚姩鍣ㄨ縼绉讳负 PowerToys Command Palette锛圕mdPal锛夌殑鐙珛 fork銆傛棫瀹炵幇宸茶縼绉诲埌 `A:\Code\MagicalGirlWand-backup`锛屾柊浠撳簱鏄?`microsoft/PowerToys` 鐨?GitHub fork锛屽苟閰嶇疆 `microsoft/PowerToys` 涓?`upstream`銆?
鐩爣涓嶆槸閲嶆柊瀹炵幇涓€涓瑙傜浉浼肩殑鍚姩鍣紝鑰屾槸瀹屾暣淇濈暀 CmdPal 瀹夸富銆佹墿灞?SDK銆佸唴缃墿灞曘€丏ock銆佸鏉傞〉闈€佽缃€佺ず渚嬪拰娴嬭瘯銆傚湪姝ゅ熀纭€涓婂垹闄や笌 CmdPal 鏃犲叧鐨?PowerToys 妯″潡锛屽畬鎴?MagicalGirlWand 鍝佺墝鍖栵紝骞舵柊澧炲熀浜?Everything SDK 鐨勬枃浠舵悳绱㈡墿灞曘€?
## 鐩爣

1. 浠?PowerToys 婧愮爜涓彁鍙栦竴涓彲鐙珛鎭㈠銆佹瀯寤恒€佹祴璇曘€佸畨瑁呭拰杩愯鐨?CmdPal 渚濊禆闂寘銆?2. 瀹屾暣淇濈暀 CmdPal 鐜版湁鍔熻兘鍜屾墿灞曟ā鍨嬨€?3. 灏嗙敤鎴峰彲瑙佸搧鐗屾敼涓?MagicalGirlWand锛屽悓鏃跺敖閲忎繚鎸佸唴閮ㄩ」鐩悕鍜屽懡鍚嶇┖闂寸ǔ瀹氾紝浠ヤ究鍚屾涓婃父銆?4. 灏?`Alt + Space` 璁句负榛樿鍞ら啋蹇嵎閿紝骞跺厑璁哥敤鎴峰湪璁剧疆涓慨鏀广€?5. 鏂板 Everything 鍐呯疆鎵╁睍锛屼负 CmdPal 鎻愪緵鍔ㄦ€佹枃浠舵悳绱㈤〉闈㈠拰棣栭〉 fallback銆?6. 淇濇寔鏄庣‘鐨勪笂娓告潵婧愩€佽鍙瘉淇℃伅鍜屽彲瀹¤鐨勮縼绉诲巻鍙层€?
## 闈炵洰鏍?
1. 涓嶈縼绉绘棫 MagicalGirlWand 鐨勭晫闈€佹悳绱㈡灦鏋勬垨鏈湴璁剧疆銆?2. 涓嶅湪绗竴杞簿绠€涓噸鍛藉悕鍏ㄩ儴 `Microsoft.CmdPal.*` 椤圭洰鎴栧懡鍚嶇┖闂淬€?3. 涓嶅垹闄や换浣?CmdPal 鍔熻兘鏉ユ崲鍙栨洿蹇殑棣栦釜鏋勫缓銆?4. 涓嶉澶栨壙璇?PowerToys CmdPal 涓婃父灏氭湭鏀寔鐨勫钩鍙般€?5. 涓嶅湪寤虹珛鍘熺増 CmdPal 鏋勫缓鍩虹嚎鍓嶅垹闄?PowerToys 婧愮爜銆?
## 浠撳簱涓庝緷璧栬竟鐣?
鏈€缁堜粨搴撲繚鐣欎互涓嬪唴瀹癸細

- 瀹屾暣鐨?`src/modules/cmdpal`锛?  - CmdPal UI 涓?ViewModel锛?  - 鎵╁睍 SDK 涓?C# Toolkit锛?  - 鎵€鏈夊唴缃墿灞曪紱
  - Dock銆佽鎯呫€佽〃鍗曘€丮arkdown銆佺綉鏍肩瓑椤甸潰鑳藉姏锛?  - 绀轰緥鎵╁睍锛?  - 鍗曞厓娴嬭瘯涓?UI 娴嬭瘯銆?- `CommandPalette.slnf` 寮曠敤鐨?`src/common` 椤圭洰銆?- `src/settings-ui/Settings.UI.Library`銆?- 琚繚鐣欓」鐩€氳繃 `ProjectReference`銆丮SBuild `Import`銆佺敓鎴愯剼鏈€佽祫婧愯矾寰勬垨娴嬭瘯宸ュ叿瀹為檯寮曠敤鐨勫叾浠栨枃浠躲€?- 蹇呴渶鐨勬牴绾?MSBuild銆丯uGet銆佷唬鐮佸垎鏋愩€佺増鏈拰璁稿彲璇佹枃浠躲€?
鏈€缁堜粨搴撳垹闄や互涓嬪唴瀹癸細

- 涓嶅睘浜?CmdPal 涓斾笉鍦ㄤ紶閫掍緷璧栭棴鍖呭唴鐨?PowerToys 妯″潡锛?- 鍙湇鍔′簬宸插垹闄ゆā鍧楃殑瀹夎銆佹祴璇曘€丆I 鎴栬祫婧愭枃浠讹紱
- 瀹屾暣 `PowerToys.slnx` 涓笌 CmdPal 鏃犲叧鐨勯」鐩叆鍙ｃ€?
鏂板缓 `MagicalGirlWand.slnx` 浣滀负鐙珛瑙ｅ喅鏂规鍏ュ彛銆備緷璧栭棴鍖呬互瀹為檯鏋勫缓鍜岄」鐩浘涓哄噯锛屼笉鑳藉彧渚濇嵁鐩綍鍚嶇О鍒ゆ柇銆?
## 杩佺Щ椤哄簭

### 闃舵 1锛氬缓绔嬩笂娓稿熀绾?
1. 鍦ㄦ湭淇敼涓婃父婧愮爜鐨勭姸鎬佷笅鎭㈠ `src/modules/cmdpal/CommandPalette.slnf`銆?2. 棣栧厛楠岃瘉 x64 Debug 鏋勫缓鍜屽彲杩愯鍖呫€?3. 杩愯 CmdPal 鍙敤鐨勫崟鍏冩祴璇曚笌 UI 娴嬭瘯锛岃褰曞洜鐜鏉′欢鏃犳硶杩愯鐨勯」鐩強鍘熷洜銆?4. 璁板綍鏋勫缓宸ュ叿銆乂isual Studio workloads銆乄indows SDK 鍜屽寘婧愯姹傘€?
### 闃舵 2锛氱敓鎴愪緷璧栭棴鍖?
1. 浠?`CommandPalette.slnf` 鐨勯」鐩垪琛ㄥ紑濮嬨€?2. 閫掑綊鏀堕泦 `ProjectReference`銆乣Import`銆佹簮鏂囦欢閾炬帴銆佺敓鎴愯剼鏈€佽祫婧愬拰娴嬭瘯渚濊禆銆?3. 鐢熸垚淇濈暀娓呭崟鍜屽垹闄ゅ€欓€夋竻鍗曘€?4. 灏嗘牴绾ф瀯寤烘枃浠惰涓烘樉寮忎緷璧栵紝涓嶅亣璁惧叾鍙绠€鍖栨浛浠ｃ€?
### 闃舵 3锛氬垎鎵圭簿绠€

1. 鎸夋ā鍧楁壒娆″垹闄や笉鐩稿叧浠ｇ爜銆?2. 姣忔壒鍒犻櫎鍚庢墽琛岄」鐩紩鐢ㄦ壂鎻忋€佹仮澶嶃€佹瀯寤哄拰鐩稿叧娴嬭瘯銆?3. 鏋勫缓澶辫触鏃跺彧淇璇ユ壒娆￠€犳垚鐨勪緷璧栨柇瑁傦紝涓嶅悓鏃惰繘琛屽搧鐗屽寲鎴?Everything 寮€鍙戙€?4. 姣忎釜鍙獙璇佹壒娆″舰鎴愮嫭绔嬫彁浜わ紝渚夸簬瀹氫綅鍜屽洖閫€銆?
### 闃舵 4锛氱嫭绔嬭В鍐虫柟妗堜笌鍝佺墝鍖?
1. 鍒涘缓 `MagicalGirlWand.slnx`銆?2. 淇敼浜у搧鏄剧ず鍚嶃€佺獥鍙ｆ爣棰樸€佸寘鏄剧ず鍚嶃€佸畨瑁呰祫浜у拰鍥炬爣銆?3. 鍒涘缓鐙珛鍖呰韩浠藉拰搴旂敤鏁版嵁鐩綍銆?4. 淇濈暀鍐呴儴 `Microsoft.CmdPal.*` 椤圭洰鍚嶅拰鍛藉悕绌洪棿銆?5. 灏嗛粯璁ゅ揩鎹烽敭鏀逛负 `Alt + Space`锛屼繚鐣欒缃〉鐨勫揩鎹烽敭淇敼鑳藉姏銆?
### 闃舵 5锛欵verything 鎵╁睍

鍦ㄧ簿绠€鍚庣殑 CmdPal 鍩虹嚎绋冲畾鍚庢柊澧?Everything 鎵╁睍锛屼笉鎶?Everything 寮€鍙戜笌渚濊禆鍒犻櫎娣峰湪鍚屼竴鎻愪氦涓€?
## CmdPal 鍔熻兘淇濈暀绛栫暐

浠ヤ笅鑳藉姏灞炰簬蹇呴』淇濈暀鑼冨洿锛?
- 棣栭〉鍛戒护銆乫allback 鍛戒护涓庢ā绯婂尮閰嶏紱
- 鍛戒护銆佸垪琛ㄩ〉銆佸姩鎬佸垪琛ㄩ〉銆佸唴瀹归〉銆佽鎯呫€佽〃鍗曘€丮arkdown 鍜岀綉鏍奸〉闈紱
- 涓婁笅鏂囧懡浠ゃ€佸弬鏁般€佺瓫閫夈€佸垎椤靛拰鐘舵€佹秷鎭紱
- 澶栭儴鎵╁睍鍙戠幇銆乄inRT/COM 閫氫俊鍜屾墿灞曠敓鍛藉懆鏈燂紱
- 鎵╁睍缂撳瓨銆乫rozen provider 鍜屽欢杩熸縺娲伙紱
- Dock銆丏ock Band 鍜屽浐瀹氬懡浠わ紱
- CmdPal 璁剧疆涓庢墿灞曡缃紱
- 褰撳墠鍐呯疆鎵╁睍銆佺ず渚嬫墿灞曞強鍏舵祴璇曘€?
濡傛灉鏌愰」鑳藉姏渚濊禆 PowerToys 鍏叡鍩虹璁炬柦锛屽垯淇濈暀鎵€闇€鍩虹璁炬柦锛岃€屼笉鏄垹闄よ鑳藉姏銆?
## Everything 鎵╁睍鏋舵瀯

鏂板 `Microsoft.CmdPal.Ext.Everything`锛岄伒寰幇鏈?Indexer 鎵╁睍鐨勭粨鏋勫拰 CmdPal SDK 绾﹀畾銆?
### `EverythingCommandsProvider`

- 浣跨敤绋冲畾鐨?provider ID銆?- 鎻愪緵涓€涓椤靛懡浠わ紝鎵撳紑 Everything 鍔ㄦ€佸垪琛ㄩ〉銆?- 鎻愪緵涓€涓椤?fallback 椤广€?- 绠＄悊 Everything 鍙敤鐘舵€侊紝骞朵笌 Indexer fallback 鍗忚皟銆?
### `EverythingPage : DynamicListPage`

- 鎺ユ敹瀹夸富鍐欏叆鐨?`SearchText`銆?- 鏌ヨ鍙樺寲鏃跺彇娑堟棫鏌ヨ骞跺垱寤烘柊鐨勬煡璇唬娆°€?- 浣跨敤 Everything IPC 鎵ц鎼滅储銆?- 灏嗗師濮嬬粨鏋滆浆鎹负 CmdPal `IListItem`銆?- 鏀寔鏂囦欢銆佹枃浠跺す鍜屽叏閮ㄧ粨鏋滅瓫閫夈€?- 鏀寔鍒嗛〉鍔犺浇锛屽苟姝ｇ‘鏇存柊 `HasMoreItems`銆?- 閫氳繃 `RaiseItemsChanged` 閫氱煡瀹夸富銆?- 涓虹┖鏌ヨ銆佹棤缁撴灉銆佹湇鍔′笉鍙敤鍜屾煡璇㈤敊璇彁渚涚嫭绔?`EmptyContent`銆?
### `FallbackEverythingItem`

- 棣栭〉鏅€氭煡璇㈣Е鍙?Everything 鎼滅储銆?- 鐩存帴璺緞鎴栧敮涓€缁撴灉鍙繑鍥炵洿鎺ュ彲鎵ц鍛戒护銆?- 澶氫釜缁撴灉杩斿洖瀵艰埅鍒伴濉煡璇㈢殑 `EverythingPage`銆?- 鏌ヨ鏇存柊蹇呴』鍙栨秷鍓嶄竴娆″伐浣滐紝杩囨湡缁撴灉涓嶅緱淇敼褰撳墠椤广€?
### `EverythingListItem`

姣忎釜缁撴灉鑷冲皯鎻愪緵锛?
- 鏂囦欢鍚嶆垨鏂囦欢澶瑰悕锛?- 瀹屾暣璺緞锛?- 鏂囦欢绫诲瀷鍜屽悎閫傜殑鍥炬爣鎴栫缉鐣ュ浘锛?- 榛樿鎵撳紑鍛戒护锛?- 澶嶅埗璺緞锛?- 鎵撳紑鎵€鍦ㄧ洰褰曪紱
- 瀵瑰彲鎵ц鏂囦欢鎻愪緵绠＄悊鍛樿繍琛岋紱
- 鍙敱 CmdPal 璇︽儏鍖哄煙娑堣垂鐨勫熀纭€鍏冩暟鎹€?
### Indexer fallback 鍗忚皟

- Windows Indexer 鎵╁睍瀹屾暣淇濈暀銆?- Everything 鍙敤鏃讹紝鎶戝埗閲嶅鐨?Indexer 棣栭〉 fallback锛岄伩鍏嶅悓涓€鏂囦欢鏌ヨ鍑虹幇涓や釜鍏ュ彛銆?- Everything 涓嶅彲鐢ㄦ椂锛屾仮澶?Indexer fallback銆?- Indexer 鐨勯椤靛懡浠ゅ拰鐙珛鎼滅储椤甸潰濮嬬粓淇濈暀銆?
## Everything 鏌ヨ鏁版嵁娴?
```text
SearchBox
  -> CmdPal ListViewModel
  -> IDynamicListPage.SearchText
  -> EverythingPage.UpdateSearchText
  -> cancel previous CancellationTokenSource
  -> Everything search adapter
  -> native Everything IPC
  -> map rows to EverythingListItem
  -> RaiseItemsChanged
  -> CmdPal fetches GetItems
  -> list UI update
```

鎵€鏈夊紓姝ユ煡璇㈤兘浣跨敤鍙栨秷浠ょ墝鍜屽崟璋冮€掑鐨勬煡璇唬娆°€傚彧鏈夊綋鍓嶄唬娆″彲浠ュ彂甯冪粨鏋溿€傚浘鏍囧拰缂╃暐鍥惧厑璁稿欢杩熷姞杞斤紝浣嗗悓鏍峰繀椤绘鏌ュ彇娑堢姸鎬併€?
## Everything 鏈湴渚濊禆

- Everything 鍘熺敓搴撴寜 CmdPal 涓婃父鏀寔鐨勫钩鍙板垎鍒墦鍖呫€?- 鍘熺敓璋冪敤灏佽鍦ㄥ崟涓€ adapter 鍚庯紝椤甸潰涓?fallback 涓嶇洿鎺ヨ皟鐢?P/Invoke銆?- adapter 鎻愪緵鍙浛鎹㈡帴鍙ｏ紝浣挎祴璇曚笉渚濊禆鏈満 Everything 鏈嶅姟銆?- DLL 缂哄け銆佹灦鏋勪笉鍖归厤銆両PC 瓒呮椂鎴?Everything 鏈繍琛屽潎杞崲涓哄彲鏄剧ず鐨勯敊璇姸鎬併€?
## 閿欒澶勭悊

### 鏋勫缓涓庣簿绠€閿欒

- 鍒犻櫎鎵规瀵艰嚧椤圭洰寮曠敤銆両mport銆佺敓鎴愯剼鏈垨璧勬簮澶辨晥鏃讹紝鏋勫缓绔嬪埢澶辫触銆?- 涓嶉€氳繃娣诲姞鏃犲叧鍏煎灞傛帺鐩栭敊璇紱鎭㈠缂哄け鐨勭湡瀹炰緷璧栨垨鎾ら攢璇ュ垹闄ゆ壒娆°€?- `MagicalGirlWand.slnx` 涓嶅緱寮曠敤浠撳簱澶栬矾寰勩€?
### 鎵╁睍閿欒

- 鍗曚釜鎵╁睍寮傚父涓嶅緱瀵艰嚧 CmdPal 瀹夸富閫€鍑恒€?- Everything 鏌ヨ寮傚父杞负鐘舵€佹秷鎭垨绌虹姸鎬侊紝骞惰褰曡瘖鏂俊鎭€?- 鏃ф煡璇㈠彇娑堝睘浜庢甯告帶鍒舵祦锛屼笉鏄剧ず涓虹敤鎴烽敊璇€?- Everything 涓嶅彲鐢ㄦ椂鍚敤 Indexer fallback銆?
### 閰嶇疆閿欒

- 鏃犳晥蹇嵎閿繚鐣欎笂涓€娆℃湁鏁堥厤缃苟鏄剧ず鍐茬獊鎻愮ず銆?- 鏂板寘韬唤浣跨敤鍏ㄦ柊鐨勮缃綅缃紝涓嶈鍙栨棫 MagicalGirlWand 璁剧疆鏂囦欢銆?
## 鍝佺墝涓庝笂娓稿悓姝?
- 鐢ㄦ埛鍙鍝佺墝缁熶竴涓?MagicalGirlWand銆?- 淇濈暀姣忎釜涓婃父婧愮爜鏂囦欢鐨?MIT 鐗堟潈澶村拰浠撳簱璁稿彲璇併€?- 鍦ㄩ」鐩枃妗ｄ腑璁板綍 PowerToys/CmdPal 鏉ユ簮鍜岃捣濮?commit銆?- `origin` 鎸囧悜 `LingMoe404/MagicalGirlWand`銆?- `upstream` 鎸囧悜 `microsoft/PowerToys`銆?- 涓婃父鍚屾浼樺厛鍚堝苟 CmdPal 鍜屼繚鐣欎緷璧栬寖鍥村唴鐨勫彉鏇达紱鏃犲叧妯″潡鍙樻洿涓嶈繘鍏ョ嫭绔嬭В鍐虫柟妗堛€?- 閬垮厤鏃犳敹鐩婄殑澶ц妯″懡鍚嶇┖闂撮噸鍐欙紝浠ラ檷浣庡悗缁悓姝ュ啿绐併€?
## 娴嬭瘯绛栫暐

### 涓婃父鍩虹嚎娴嬭瘯

- `CommandPalette.slnf` 鎭㈠鎴愬姛銆?- x64 Debug 鏋勫缓鎴愬姛銆?- 鍙敓鎴愬苟鍚姩 CmdPal 鍖呫€?- 璁板綍鍙墽琛岀殑 CmdPal 鍗曞厓娴嬭瘯鍜?UI 娴嬭瘯缁撴灉銆?
### 绮剧畝鍥炲綊娴嬭瘯

- 姣忔壒鍒犻櫎鍚庤繍琛屾仮澶嶅拰鏋勫缓銆?- 鎵弿鎸囧悜涓嶅瓨鍦ㄨ矾寰勭殑 `ProjectReference`銆乣Import` 鍜岃祫婧愬紩鐢ㄣ€?- 杩愯鍙楄鎵规褰卞搷鐨勬祴璇曢」鐩€?- 鏈€缁堜粠骞插噣鍏嬮殕楠岃瘉锛屼笉渚濊禆鏈湴鏈窡韪枃浠躲€?
### Everything 鍗曞厓娴嬭瘯

- 绌烘煡璇笉璁块棶 IPC銆?- 鏅€氭煡璇㈡纭槧灏勭粨鏋溿€?- 鏂囦欢銆佹枃浠跺す绛涢€夋纭€?- 鍒嗛〉鏃犻噸澶嶅拰閬楁紡銆?- 鏂版煡璇㈠彇娑堟棫鏌ヨ銆?- 鏃ф煡璇㈡櫄杩斿洖涓嶈兘瑕嗙洊鏂扮粨鏋溿€?- 鏈嶅姟涓嶅彲鐢ㄤ骇鐢熷彲鎿嶄綔閿欒鐘舵€併€?- Everything 涓嶅彲鐢ㄦ椂鎭㈠ Indexer fallback銆?- 涓婁笅鏂囧懡浠ょ敓鎴愭纭殑鐩爣鍜屽弬鏁般€?
### 闆嗘垚涓庡啋鐑熸祴璇?
- 搴旂敤鍗曞疄渚嬭繍琛屻€?- 榛樿 `Alt + Space` 鍞ら啋搴旂敤銆?- 璁剧疆淇敼蹇嵎閿悗鏂板揩鎹烽敭鐢熸晥銆?- 棣栭〉銆佸鑸€佽缃€丏ock 鍜屼唬琛ㄦ€х殑鍐呯疆鎵╁睍鍙敤銆?- Everything 棣栭〉鍛戒护鎵撳紑鍔ㄦ€侀〉闈€?- Everything fallback 鑳戒粠棣栭〉鏌ヨ杩涘叆缁撴灉鎴栨悳绱㈤〉闈€?- Everything 鏁呴殰涓嶅奖鍝嶅叾浠?CmdPal 鎵╁睍銆?
## 楠屾敹鏍囧噯

1. 骞插噣鍏嬮殕鍙互鎸夋枃妗ｆ仮澶嶅拰鏋勫缓 `MagicalGirlWand.slnx`銆?2. 浠撳簱涓笉瀛樺湪涓?CmdPal 鏃犲叧涓斾笉鍦ㄤ紶閫掍緷璧栭棴鍖呭唴鐨?PowerToys 妯″潡銆?3. CmdPal 瀹夸富銆丼DK銆佸唴缃墿灞曘€丏ock銆佸鏉傞〉闈€佽缃€佺ず渚嬪拰娴嬭瘯鍧囦繚鐣欍€?4. MagicalGirlWand 浣跨敤鐙珛鍝佺墝銆佸寘韬唤鍜屾暟鎹洰褰曘€?5. 榛樿蹇嵎閿负 `Alt + Space`锛屽苟鍙湪璁剧疆涓慨鏀广€?6. Everything 鍔ㄦ€侀〉闈㈠拰 fallback 鍙敤锛屾敮鎸佸彇娑堛€佸垎椤靛拰閿欒鐘舵€併€?7. Everything 涓嶅彲鐢ㄦ椂 Indexer fallback 鍙敤銆?8. 鎵€鏈夊湪褰撳墠寮€鍙戠幆澧冨彲鎵ц鐨勪繚鐣欐祴璇曢€氳繃锛涙棤娉曟墽琛岀殑娴嬭瘯鍏锋湁鏄庣‘鐨勭幆澧冭鏄庛€?9. `origin` 鍜?`upstream` 閰嶇疆鍙婁笂娓告潵婧愭枃妗ｆ纭€?
## 瀹炴柦杈圭晫

瀹炴柦蹇呴』鍒嗕负鍙嫭绔嬮獙璇佺殑璁″垝浠诲姟锛氫笂娓稿熀绾裤€佷緷璧栭棴鍖呫€佸垎鎵圭簿绠€銆佺嫭绔嬭В鍐虫柟妗堛€佸搧鐗屽寲銆丒verything adapter銆丒verything 椤甸潰銆乫allback 鍗忚皟銆佹祴璇曚笌鏈€缁堥獙璇併€備换涓€浠诲姟澶辫触鏃跺仠姝㈡墿澶ф敼鍔ㄨ寖鍥达紝鍏堟仮澶嶈浠诲姟鐨勫彲楠岃瘉鐘舵€併€?
