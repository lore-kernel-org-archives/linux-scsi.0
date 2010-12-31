From: Christian Schmidt <charlie@digadd.de>
Subject: Linux support for the LSI SAS8208ELP
Date: Fri, 31 Dec 2010 17:43:29 +0100
Message-ID: <4D1E0831.8090602@digadd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.digadd.de ([195.47.195.236]:54169 "EHLO mx1.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753023Ab0LaRKM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Dec 2010 12:10:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>, support@lsi.com, linux-scsi@vger.kernel.org

Hi,

I've recently bought a mainboard that's equipped with a device that is
identified (by lspci) as LSI SAS8208ELP (Vendor ID 0x1000, Device ID
0x0059). It's not currently supported by the Linux kernel, but appears
to be working with the mpt fusion sas driver.

echo "0x1000 0x0059" >/sys/bus/pci/drivers/mptsas/new_id

brings the chip online. It seems I'm not the only one with this chip, see

http://forums.gentoo.org/viewtopic-t-731366.html
http://bugs.gentoo.org/325805
http://bugs.gentoo.org/attachment.cgi?id=236721 (patch to add the device ID)
http://ubuntuforums.org/showthread.php?t=1519373

and more.

Since LSI seems to only provide closed source drivers for far obsolete
and limited "enterprise" distribution kernels I'd suggest the inclusion
of the PCI IDs into the kernel.

Regards,
Christian

PS: Here's a full list of device IDs:

[/tmp]>modinfo megasr.ko
filename:       megasr.ko
license:        LSI Proprietary
description:    LSI Software RAID5 Driver
version:        13.15.1218.2009
author:         LSI Corporation
alias:          pci:v00008086d00002683sv00001734sd000010C9bc*sc*i*
alias:          pci:v00008086d00002683sv00001734sd00001090bc*sc*i*
alias:          pci:v00008086d00002683sv00001734sd000010A0bc*sc*i*
alias:          pci:v00008086d00002682sv0000193Dsd00003000bc*sc*i*
alias:          pci:v00008086d00002682sv00001458sd0000B003bc*sc*i*
alias:          pci:v00008086d00002682sv0000152Dsd00008950bc*sc*i*
alias:          pci:v00008086d00002682sv0000144Dsd0000D001bc*sc*i*
alias:          pci:v00008086d00002682sv00001458sd0000346Dbc*sc*i*
alias:          pci:v00008086d00002682sv000017AAsd00006B64bc*sc*i*
alias:          pci:v00008086d00002682sv000017AAsd00006B7Cbc*sc*i*
alias:          pci:v00008086d00002682sv000015D9sd00008980bc*sc*i*
alias:          pci:v00008086d00002682sv000015D9sd00008880bc*sc*i*
alias:          pci:v00008086d00002682sv000015D9sd00008480bc*sc*i*
alias:          pci:v00008086d00002682sv000015D9sd00008380bc*sc*i*
alias:          pci:v00008086d00002682sv000015D9sd00008180bc*sc*i*
alias:          pci:v00008086d00002682sv000015D9sd00008080bc*sc*i*
alias:          pci:v00008086d00002682sv0000107Bsd00009570bc*sc*i*
alias:          pci:v00008086d00002682sv0000107Bsd00009565bc*sc*i*
alias:          pci:v00008086d00002682sv00001170sd00000023bc*sc*i*
alias:          pci:v00008086d00002682sv00001043sd000081FFbc*sc*i*
alias:          pci:v00008086d00002682sv00001033sd00008361bc*sc*i*
alias:          pci:v00008086d00002682sv00001033sd00008360bc*sc*i*
alias:          pci:v00008086d00002682sv00001033sd0000833Cbc*sc*i*
alias:          pci:v00008086d00002682sv00001033sd00008338bc*sc*i*
alias:          pci:v00008086d00002682sv00001033sd00008336bc*sc*i*
alias:          pci:v00008086d00002682sv00001734sd0000110Dbc*sc*i*
alias:          pci:v00008086d00002682sv00001734sd000010C9bc*sc*i*
alias:          pci:v00008086d00002682sv00001734sd00001090bc*sc*i*
alias:          pci:v00008086d00002682sv00001734sd000010DAbc*sc*i*
alias:          pci:v00008086d00002682sv00001734sd000010A0bc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd000034CDbc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd000034D5bc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd00003497bc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd00003495bc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd00003493bc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd00003491bc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd00003487bc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd00003485bc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd00003483bc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd00003481bc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd0000347Dbc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd0000347Bbc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd00003479bc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd00003477bc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd00003475bc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd00003473bc*sc*i*
alias:          pci:v00008086d00002682sv00008086sd0000346Dbc*sc*i*
alias:          pci:v00001000d00000055sv0000144Dsd0000D001bc*sc*i*
alias:          pci:v00001000d00000055sv000017AAsd00006B64bc*sc*i*
alias:          pci:v00001000d00000055sv0000107Bsd00009570bc*sc*i*
alias:          pci:v00001000d00000055sv0000107Bsd00009565bc*sc*i*
alias:          pci:v00001000d00000055sv00001170sd00000023bc*sc*i*
alias:          pci:v00001000d00000055sv00001033sd00008342bc*sc*i*
alias:          pci:v00001000d00000055sv00001033sd00008338bc*sc*i*
alias:          pci:v00001000d00000055sv00001033sd00008337bc*sc*i*
alias:          pci:v00001000d00000055sv00001033sd00008336bc*sc*i*
alias:          pci:v00001000d00000055sv00008086sd00003507bc*sc*i*
alias:          pci:v00001000d00000055sv00008086sd00003504bc*sc*i*
alias:          pci:v00001000d00000055sv00008086sd00003501bc*sc*i*
alias:          pci:v00001000d00000055sv00008086sd00003500bc*sc*i*
alias:          pci:v00001000d00000055sv00008086sd00003491bc*sc*i*
alias:          pci:v00001000d00000055sv00008086sd0000346Dbc*sc*i*
alias:          pci:v00001000d00000055sv00008086sd0000346Cbc*sc*i*
alias:          pci:v00001000d00000055sv00001000sd00003005bc*sc*i*
alias:          pci:v00001000d00000055sv00001000sd00003001bc*sc*i*
alias:          pci:v00001000d00000059sv00001462sd00006C80bc*sc*i*
alias:          pci:v00001000d00000059sv0000152Dsd00008963bc*sc*i*
alias:          pci:v00001000d00000059sv00008086sd00003002bc*sc*i*
alias:          pci:v00001000d00000059sv0000152Dsd00008969bc*sc*i*
alias:          pci:v00001000d00000059sv000010F1sd00007005bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000001Fbc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000001Ebc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000001Dbc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000001Cbc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000001Bbc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000001Abc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000019bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000018bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000017bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000011bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000015bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000014bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000013bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000012bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000011bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000010bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000000Fbc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000000Ebc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000000Dbc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000000Cbc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000000Bbc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000000Abc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000009bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000008bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000007bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000006bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000005bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000004bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000003bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000002bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000001bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd00000000bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A911bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A811bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A711bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A611bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A511bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A411bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A311bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A211bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A111bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A011bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A980bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A880bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A780bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A680bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A580bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A480bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A380bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A280bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A180bc*sc*i*
alias:          pci:v00001000d00000059sv000015D9sd0000A080bc*sc*i*
alias:          pci:v00001000d00000059sv00001043sd000082CDbc*sc*i*
alias:          pci:v00001000d00000059sv00001025sd00001000bc*sc*i*
alias:          pci:v00001000d00000059sv00001458sd00001000bc*sc*i*
alias:          pci:v00001000d00000059sv0000107Bsd00009570bc*sc*i*
alias:          pci:v00001000d00000059sv0000107Bsd00009565bc*sc*i*
alias:          pci:v00001000d00000059sv00001170sd00000023bc*sc*i*
alias:          pci:v00001000d00000059sv00001734sd0000115Abc*sc*i*
alias:          pci:v00001000d00000059sv00001000sd00003006bc*sc*i*
alias:          pci:v00001000d00000059sv00001000sd00003002bc*sc*i*
alias:          pci:v00001000d00000059sv00001B0Asd00000013bc*sc*i*
alias:          pci:v00001000d00000057sv00001462sd00006C80bc*sc*i*
alias:          pci:v00001000d00000057sv0000152Dsd00008963bc*sc*i*
alias:          pci:v00001000d00000057sv0000152Dsd0000896Dbc*sc*i*
alias:          pci:v00001000d00000057sv000015D9sd00000000bc*sc*i*
alias:          pci:v00001000d00000057sv00001054sd00003017bc*sc*i*
alias:          pci:v00001000d00000057sv0000107Bsd00009570bc*sc*i*
alias:          pci:v00001000d00000057sv0000107Bsd00009565bc*sc*i*
alias:          pci:v00001000d00000057sv00001170sd00000023bc*sc*i*
alias:          pci:v00001000d00000057sv00001033sd0000833Cbc*sc*i*
alias:          pci:v00001000d00000057sv00001043sd0000830Bbc*sc*i*
alias:          pci:v00001000d00000057sv00008086sd000034DCbc*sc*i*
alias:          pci:v00001000d00000057sv00008086sd00003487bc*sc*i*
alias:          pci:v00001000d00000057sv00008086sd00003486bc*sc*i*
alias:          pci:v00001000d00000057sv00008086sd00003483bc*sc*i*
alias:          pci:v00001000d00000057sv00008086sd00003482bc*sc*i*
alias:          pci:v00001000d00000057sv00008086sd0000347Dbc*sc*i*
alias:          pci:v00001000d00000057sv00008086sd0000347Cbc*sc*i*
alias:          pci:v00001000d00000057sv00008086sd0000347Bbc*sc*i*
alias:          pci:v00001000d00000057sv00008086sd0000347Abc*sc*i*
alias:          pci:v00001000d00000057sv00008086sd00003479bc*sc*i*
alias:          pci:v00001000d00000057sv00008086sd00003478bc*sc*i*
alias:          pci:v00001000d00000057sv00008086sd00003475bc*sc*i*
alias:          pci:v00001000d00000057sv00008086sd00003474bc*sc*i*
alias:          pci:v00001000d00000057sv00008086sd0000346Dbc*sc*i*
alias:          pci:v00001000d00000057sv00008086sd0000346Cbc*sc*i*
alias:          pci:v00001000d00000057sv00001000sd00001000bc*sc*i*
alias:          pci:v00008086d00003B25sv00001025sd00000339bc*sc*i*
alias:          pci:v00008086d00003B25sv00001025sd0000033Abc*sc*i*
alias:          pci:v00008086d00003B25sv00001025sd00000332bc*sc*i*
alias:          pci:v00008086d00003B25sv00001033sd00008389bc*sc*i*
alias:          pci:v00008086d00003B25sv00001033sd00008391bc*sc*i*
alias:          pci:v00008086d00003B25sv00001033sd00008390bc*sc*i*
alias:          pci:v00008086d00003B25sv00001458sd00003B20bc*sc*i*
alias:          pci:v00008086d00003B25sv00001458sd00002000bc*sc*i*
alias:          pci:v00008086d00003B25sv00001458sd00001001bc*sc*i*
alias:          pci:v00008086d00003B25sv00001458sd00001000bc*sc*i*
alias:          pci:v00008086d00003B25sv00001043sd000083C2bc*sc*i*
alias:          pci:v00008086d00003B25sv00008086sd000034EDbc*sc*i*
alias:          pci:v00008086d00003B25sv00001734sd00001167bc*sc*i*
alias:          pci:v00008086d00003A25sv0000152Dsd0000897Abc*sc*i*
alias:          pci:v00008086d00003A25sv0000152Dsd0000897Bbc*sc*i*
alias:          pci:v00008086d00003A25sv0000152Dsd00008975bc*sc*i*
alias:          pci:v00008086d00003A25sv00001137sd00000067bc*sc*i*
alias:          pci:v00008086d00003A25sv00001734sd00001155bc*sc*i*
alias:          pci:v00008086d00003A25sv0000152Dsd00008969bc*sc*i*
alias:          pci:v00008086d00003A25sv0000152Dsd0000896Dbc*sc*i*
alias:          pci:v00008086d00003A25sv0000152Dsd00008963bc*sc*i*
alias:          pci:v00008086d00003A25sv00008086sd000034EBbc*sc*i*
alias:          pci:v00008086d00003A25sv00008086sd000034E9bc*sc*i*
alias:          pci:v00008086d00003A25sv00008086sd000034E3bc*sc*i*
alias:          pci:v00008086d00003A25sv00008086sd000034DFbc*sc*i*
alias:          pci:v00008086d00003A25sv00008086sd000034DDbc*sc*i*
alias:          pci:v00008086d00003A25sv00008086sd000034DBbc*sc*i*
alias:          pci:v00008086d00003A25sv00001033sd0000839Abc*sc*i*
alias:          pci:v00008086d00003A25sv00001033sd00008397bc*sc*i*
alias:          pci:v00008086d00003A25sv000017AAsd00006B7Dbc*sc*i*
alias:          pci:v00008086d00003A25sv00001458sd00001001bc*sc*i*
alias:          pci:v00008086d00003A25sv00001458sd00001000bc*sc*i*
alias:          pci:v00008086d00003A25sv00001025sd0000017Abc*sc*i*
alias:          pci:v00008086d00003A25sv00001025sd00000179bc*sc*i*
alias:          pci:v00008086d00003A25sv00001025sd00001000bc*sc*i*
alias:          pci:v00008086d00003A25sv00001043sd00008365bc*sc*i*
alias:          pci:v00008086d00003A25sv00001734sd00001150bc*sc*i*
alias:          pci:v00008086d00003A25sv00001033sd00008372bc*sc*i*
alias:          pci:v00008086d00003A25sv00001033sd00008371bc*sc*i*
alias:          pci:v00008086d00003A25sv00001033sd00008370bc*sc*i*
alias:          pci:v00008086d00003A25sv00001033sd0000836Fbc*sc*i*
alias:          pci:v00008086d00002925sv0000152Dsd00008960bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000FF80bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000FE80bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000FD80bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000FC80bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000FB80bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000FA80bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000F980bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000F880bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000F780bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000F680bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000F580bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000F480bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000F380bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000F280bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000F180bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000F080bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000DF80bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000DE80bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000DD80bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000DC80bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000DB80bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000DA80bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000D980bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000D880bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000D780bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000D680bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000D580bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000D480bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000D380bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000D280bc*sc*i*
alias:          pci:v00008086d00002925sv000015D9sd0000D180bc*sc*i*
alias:          pci:v00008086d00002925sv00001043sd000082F0bc*sc*i*
alias:          pci:v00008086d00002925sv000017AAsd00009D5Cbc*sc*i*
alias:          pci:v00008086d00002925sv00001025sd00001000bc*sc*i*
alias:          pci:v00008086d00002925sv00001458sd00002920bc*sc*i*
alias:          pci:v00008086d00002925sv00001458sd00001000bc*sc*i*
alias:          pci:v00008086d00002925sv00001033sd0000888Dbc*sc*i*
alias:          pci:v00008086d00002925sv00001033sd00008381bc*sc*i*
alias:          pci:v00008086d00002925sv00001033sd00008366bc*sc*i*
alias:          pci:v00008086d00002925sv00001033sd00008365bc*sc*i*
alias:          pci:v00008086d00002925sv00001033sd00008362bc*sc*i*
alias:          pci:v00008086d00002925sv00001033sd0000835Ebc*sc*i*
alias:          pci:v00008086d00002925sv00001734sd000010E0bc*sc*i*
alias:          pci:v00008086d00002925sv00008086sd000034D1bc*sc*i*
alias:          pci:v00008086d00002925sv00008086sd000034CFbc*sc*i*
alias:          pci:v00008086d00002925sv00001462sd00006650bc*sc*i*
alias:          pci:v00008086d00002925sv00001462sd00006560bc*sc*i*
alias:          pci:v00008086d000027C3sv00001033sd0000834Fbc*sc*i*
alias:          pci:v00008086d000027C3sv00001043sd0000819Ebc*sc*i*
alias:          pci:v00008086d000027C3sv00001458sd000027C0bc*sc*i*
alias:          pci:v00008086d000027C3sv00001458sd000027C3bc*sc*i*
alias:          pci:v00008086d000027C3sv00001033sd00008352bc*sc*i*
alias:          pci:v00008086d000027C3sv00001033sd00008351bc*sc*i*
alias:          pci:v00008086d000027C3sv00001033sd000082E8bc*sc*i*
alias:          pci:v00008086d000027C3sv00001033sd0000834Ebc*sc*i*
alias:          pci:v00008086d000027C3sv00008086sd00003489bc*sc*i*
alias:          pci:v00008086d000027C3sv00001734sd000010A5bc*sc*i*
depends:        scsi_mod
vermagic:       2.6.9-55.EL gcc-3.4
parm:           dbglvl_g:driver-wide debug flag
