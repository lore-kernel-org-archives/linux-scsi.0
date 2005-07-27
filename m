From: "conway, heather" <conway_heather@emc.com>
Subject: Request to add EMC Invista to the v2.6.x SCSI Blacklist...
Date: Wed, 27 Jul 2005 10:22:27 -0400
Message-ID: <FA2F59D0E55B4B4892EA076FF8704F5509DDC7A5@srgraham.eng.emc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C592B6.93FB20CE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.lss.emc.com ([168.159.2.31]:47572 "EHLO
	mailhub.lss.emc.com") by vger.kernel.org with ESMTP id S262259AbVG0OWc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2005 10:22:32 -0400
Received: from srexchimc2.eng.emc.com (srexchimg2.eng.emc.com [168.159.100.11] (may be forged))
	by mailhub.lss.emc.com (Switch-3.1.6/Switch-3.1.6) with ESMTP id j6REMUvL007999
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2005 10:22:30 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C592B6.93FB20CE
Content-Type: text/plain

Hi,
I'd like to request that the enclosed patch to scsi_devinfo.c be considered
for inclusion in the v2.6.x kernel.  This would add support for sparse LUNs
and large LUNs for the EMC Invista product.  
Thanks for your consideration.
Heather
 <<scsi_devinfo_invista.patch>> 

------_=_NextPart_000_01C592B6.93FB20CE
Content-Type: application/octet-stream;
	name="scsi_devinfo_invista.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="scsi_devinfo_invista.patch"

--- scsi_devinfo.c	2005-07-06 14:55:11.892645608 -0400=0A=
+++ /root/scsi_devinfo.c	2005-07-06 14:54:57.558824680 -0400=0A=
@@ -136,6 +136,7 @@=0A=
 	{"DELL", "PERCRAID", NULL, BLIST_FORCELUN},=0A=
 	{"DGC", "RAID", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, storage on =
LUN 0 */=0A=
 	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, no storage =
on LUN 0 */=0A=
+	{"EMC", "Invista", NULL, BLIST_SPARSELUN | BLIST_LARGELUN}, =
/*Invista, no storage on LUN 0 */=0A=
 	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | =
BLIST_FORCELUN},=0A=
 	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},=0A=
 	{"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},=0A=

------_=_NextPart_000_01C592B6.93FB20CE--
