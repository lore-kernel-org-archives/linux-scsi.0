From: Gregoire Favre <Gregoire.Favre@freesurf.ch>
Subject: How to add a device to the multiple LUN "list" ?
Date: Tue, 13 Jul 2004 17:39:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040713153934.GB20269@magma.epfl.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail3.epfl.ch ([128.178.50.19]:7435 "HELO mail3.epfl.ch")
	by vger.kernel.org with SMTP id S265356AbUGMPjh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 11:39:37 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I have an Maxxtro USB 2.0 8in1 CardReader/Writer which works perfectly
if I set probe for multiple LUN in SCSI, but as I have an all SCSI
device, it really slow down my boot process...

How could I add my 8in1 to the "list" of device that have to be probed
for all LUN ?

T:  Bus=3D01 Lev=3D01 Prnt=3D01 Port=3D03 Cnt=3D01 Dev#=3D  3 Spd=3D480=
 MxCh=3D 0
D:  Ver=3D 2.00 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D64 #Cfgs=3D  =
1
P:  Vendor=3D0424 ProdID=3D20fc Rev=3D 1.97
S:  Manufacturer=3DSMSC
S:  Product=3DUSB 2 Flash Media Device
S:  SerialNumber=3D7777777777A6
C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3D80 MxPwr=3D 96mA
I:  If#=3D 0 Alt=3D 0 #EPs=3D 2 Cls=3D08(stor.) Sub=3D06 Prot=3D50
Driver=3Dusb-storage
E:  Ad=3D02(O) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D125us
E:  Ad=3D82(I) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms

Thank you very much, and please CC to me as I am not on the list.
--=20
	Gr=E9goire Favre
_______________________________________________________________________=
_
http://magma.epfl.ch/greg ICQ:16624071 mailto:Gregoire.Favre@freesurf.c=
h
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
