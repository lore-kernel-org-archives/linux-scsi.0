From: Wakko Warner <wakko@animx.eu.org>
Subject: mpt2sas errors help
Date: Wed, 21 Sep 2011 19:45:35 -0400
Message-ID: <20110921234535.GA1972@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:50614 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab1IVAFA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Sep 2011 20:05:00 -0400
Received: from wakko by animx.eu.org with local
	(Exim 4.69 #3 (Debian Bug?  What bug /\oo/\))
	id 1R6WTv-0000e3-Qr
	for linux-scsi@vger.kernel.org; Wed, 21 Sep 2011 19:45:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm seeing tons of these ever 2-4 minutes during a raid rebuild (new raid on
new disks)

These are 2tb seagate green 5900 sata disks.  I have an external enclosure
attached to an lsi 6gb sas controller.

This happens on ID 0:0:5:0 (first disk, sdd phy-4, in the enclosure) and on
ID 0:0:8:0 (4th disk, sdg phy-7, in the enclosure).  I have not seen it on
0:0:6:0 (sde phy-5) or 0:0:7:0 (sdf phy-6).  The cable is an sff8088 to
sff8088.  The sas controller has an sff8088 connector.

I assume the link on these devices are 6.0gb.

Can someone tell me what is happening?

Here's the dmesg:
[6938625.516581] sd 0:0:8:0: attempting task abort! scmd(ffff8802ede2fc80)
[6938625.516588] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 cf 90 00 00 30 00
[6938625.516603] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.516608] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.662796] sd 0:0:8:0: task abort: SUCCESS scmd(ffff8802ede2fc80)
[6938625.825901] sd 0:0:8:0: attempting task abort! scmd(ffff880236f4adc0)
[6938625.825907] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 cf c0 00 00 30 00
[6938625.825922] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.825927] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.825941] sd 0:0:8:0: task abort: SUCCESS scmd(ffff880236f4adc0)
[6938625.826200] sd 0:0:8:0: attempting task abort! scmd(ffff8802a485dbc0)
[6938625.826206] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 cf f0 00 00 30 00
[6938625.826220] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.826225] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.826237] sd 0:0:8:0: task abort: SUCCESS scmd(ffff8802a485dbc0)
[6938625.826444] sd 0:0:8:0: attempting task abort! scmd(ffff88031c3376c0)
[6938625.826448] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d0 20 00 00 98 00
[6938625.826461] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.826465] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.826477] sd 0:0:8:0: task abort: SUCCESS scmd(ffff88031c3376c0)
[6938625.826677] sd 0:0:8:0: attempting task abort! scmd(ffff8800197a58c0)
[6938625.826681] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d0 b8 00 00 10 00
[6938625.826694] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.826698] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.826710] sd 0:0:8:0: task abort: SUCCESS scmd(ffff8800197a58c0)
[6938625.826891] sd 0:0:8:0: attempting task abort! scmd(ffff8802a53b7d80)
[6938625.826896] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d0 c8 00 00 08 00
[6938625.826908] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.826912] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.826924] sd 0:0:8:0: task abort: SUCCESS scmd(ffff8802a53b7d80)
[6938625.827098] sd 0:0:8:0: attempting task abort! scmd(ffff8800197a57c0)
[6938625.827103] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d0 d0 00 00 30 00
[6938625.827115] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.827119] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.827130] sd 0:0:8:0: task abort: SUCCESS scmd(ffff8800197a57c0)
[6938625.827363] sd 0:0:8:0: attempting task abort! scmd(ffff8800abde5480)
[6938625.827369] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d1 00 00 00 20 00
[6938625.827383] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.827388] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.827400] sd 0:0:8:0: task abort: SUCCESS scmd(ffff8800abde5480)
[6938625.827584] sd 0:0:8:0: attempting task abort! scmd(ffff8800abde5080)
[6938625.827589] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d1 20 00 00 88 00
[6938625.827602] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.827606] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.827618] sd 0:0:8:0: task abort: SUCCESS scmd(ffff8800abde5080)
[6938625.827793] sd 0:0:8:0: attempting task abort! scmd(ffff8801d2c77580)
[6938625.827797] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d1 a8 00 00 08 00
[6938625.827809] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.827814] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.827825] sd 0:0:8:0: task abort: SUCCESS scmd(ffff8801d2c77580)
[6938625.828013] sd 0:0:8:0: attempting task abort! scmd(ffff880130f50d80)
[6938625.828018] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d1 b0 00 00 08 00
[6938625.828030] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.828034] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.828046] sd 0:0:8:0: task abort: SUCCESS scmd(ffff880130f50d80)
[6938625.828231] sd 0:0:8:0: attempting task abort! scmd(ffff88031ad6b080)
[6938625.828236] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d1 b8 00 00 08 00
[6938625.828248] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.828252] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.828264] sd 0:0:8:0: task abort: SUCCESS scmd(ffff88031ad6b080)
[6938625.828483] sd 0:0:8:0: attempting task abort! scmd(ffff880130f9d5c0)
[6938625.828488] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d1 c0 00 00 08 00
[6938625.828516] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.828521] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.828533] sd 0:0:8:0: task abort: SUCCESS scmd(ffff880130f9d5c0)
[6938625.828691] sd 0:0:8:0: attempting task abort! scmd(ffff88011ea9da80)
[6938625.828695] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d1 c8 00 00 08 00
[6938625.828712] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.828715] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.828724] sd 0:0:8:0: task abort: SUCCESS scmd(ffff88011ea9da80)
[6938625.828917] sd 0:0:8:0: attempting task abort! scmd(ffff8801c41ed1c0)
[6938625.828920] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d1 d0 00 00 98 00
[6938625.828928] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.828930] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.828938] sd 0:0:8:0: task abort: SUCCESS scmd(ffff8801c41ed1c0)
[6938625.829119] sd 0:0:8:0: attempting task abort! scmd(ffff8800abde5e80)
[6938625.829122] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d2 68 00 00 60 00
[6938625.829129] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.829131] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.829139] sd 0:0:8:0: task abort: SUCCESS scmd(ffff8800abde5e80)
[6938625.829328] sd 0:0:8:0: attempting task abort! scmd(ffff880143bd52c0)
[6938625.829331] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d2 c8 00 00 f8 00
[6938625.829338] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.829340] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.829347] sd 0:0:8:0: task abort: SUCCESS scmd(ffff880143bd52c0)
[6938625.829534] sd 0:0:8:0: attempting task abort! scmd(ffff8800704db480)
[6938625.829536] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d3 c0 00 00 50 00
[6938625.829543] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.829546] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.829553] sd 0:0:8:0: task abort: SUCCESS scmd(ffff8800704db480)
[6938625.829737] sd 0:0:8:0: attempting task abort! scmd(ffff8802e82ce8c0)
[6938625.829740] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d4 10 00 00 60 00
[6938625.829747] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.829749] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.829756] sd 0:0:8:0: task abort: SUCCESS scmd(ffff8802e82ce8c0)
[6938625.829940] sd 0:0:8:0: attempting task abort! scmd(ffff8802a53b7480)
[6938625.829943] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d4 70 00 00 38 00
[6938625.829950] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.829952] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.829959] sd 0:0:8:0: task abort: SUCCESS scmd(ffff8802a53b7480)
[6938625.830141] sd 0:0:8:0: attempting task abort! scmd(ffff88011ba0a4c0)
[6938625.830144] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d4 a8 00 00 60 00
[6938625.830151] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.830153] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.830161] sd 0:0:8:0: task abort: SUCCESS scmd(ffff88011ba0a4c0)
[6938625.830345] sd 0:0:8:0: attempting task abort! scmd(ffff8802ede2e5c0)
[6938625.830347] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d5 08 00 00 d0 00
[6938625.830354] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.830357] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.830364] sd 0:0:8:0: task abort: SUCCESS scmd(ffff8802ede2e5c0)
[6938625.830542] sd 0:0:8:0: attempting task abort! scmd(ffff8802ede2f080)
[6938625.830545] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d5 d8 00 00 b0 00
[6938625.830551] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.830554] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.830562] sd 0:0:8:0: task abort: SUCCESS scmd(ffff8802ede2f080)
[6938625.830739] sd 0:0:8:0: attempting task abort! scmd(ffff88011bbc4180)
[6938625.830742] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d6 88 00 00 30 00
[6938625.830748] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.830751] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.830758] sd 0:0:8:0: task abort: SUCCESS scmd(ffff88011bbc4180)
[6938625.830948] sd 0:0:8:0: attempting task abort! scmd(ffff88031c2405c0)
[6938625.830951] sd 0:0:8:0: [sdg] CDB: cdb[0]=0x2a: 2a 00 2c 05 d6 b8 00 00 28 00
[6938625.830958] scsi target0:0:8: handle(0x000f), sas_address(0x4433221103000000), phy(3)
[6938625.830960] scsi target0:0:8: enclosure_logical_id(0x500605b001d0ab00), slot(3)
[6938625.830967] sd 0:0:8:0: task abort: SUCCESS scmd(ffff88031c2405c0)
[6938626.380240] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380248] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380253] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380258] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380263] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380267] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380272] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380276] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380281] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380286] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380290] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380295] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380299] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380304] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380318] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380323] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380346] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380351] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380356] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380360] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380374] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380379] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380392] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380397] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380412] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380417] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.380425] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480517] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480525] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480530] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480544] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480548] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480562] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480566] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480580] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480595] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480598] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480609] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480619] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480630] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480640] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480643] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480654] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480665] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480676] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480688] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480691] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480702] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480713] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480724] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480727] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480739] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480750] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.480761] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524233] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524240] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524245] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524250] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524255] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524259] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524264] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524268] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524273] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524278] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524282] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524287] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524301] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524305] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524318] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524323] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524347] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524352] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524357] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524362] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524375] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524380] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524394] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524398] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524412] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524418] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.524423] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612152] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612159] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612164] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612169] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612174] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612178] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612183] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612197] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612202] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612215] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612228] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612233] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612246] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612251] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612265] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612269] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612285] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612287] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612299] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612310] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612321] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612336] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612340] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612350] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612361] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612364] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
[6938626.612375] mpt2sas0: log_info(0x31110e00): originator(PL), code(0x11), sub_code(0x0e00)
