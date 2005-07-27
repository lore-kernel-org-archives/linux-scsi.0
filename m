From: "conway, heather" <conway_heather@emc.com>
Subject: Request to add EMC Invista to the v2.4.x SCSI Blacklist...
Date: Wed, 27 Jul 2005 10:22:22 -0400
Message-ID: <FA2F59D0E55B4B4892EA076FF8704F5509DDC7A4@srgraham.eng.emc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C592B6.0CE1AFB6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.lss.emc.com ([168.159.2.31]:39636 "EHLO
	mailhub.lss.emc.com") by vger.kernel.org with ESMTP id S262092AbVG0OW0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2005 10:22:26 -0400
Received: from srexchimc2.eng.emc.com (srexchimg2.eng.emc.com [168.159.100.11] (may be forged))
	by mailhub.lss.emc.com (Switch-3.1.6/Switch-3.1.6) with ESMTP id j6REMO2F005942
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2005 10:22:24 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux_SCSI (linux-scsi@vger.kernel.org)" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C592B6.0CE1AFB6
Content-Type: text/plain

Hi,
I'd like to request that the enclosed patch to scsi_scan.c be considered for
inclusion in the v2.4.x kernel.  This would add support for sparse LUNs and
large LUNs for the EMC Invista product.  
Thanks for your consideration.
Heather
 <<scsi_scan_invista.patch>> 

------_=_NextPart_000_01C592B6.0CE1AFB6
Content-Type: application/octet-stream;
	name="scsi_scan_invista.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="scsi_scan_invista.patch"

--- scsi_scan.c	2005-07-06 13:08:42.000000000 -0400=0A=
+++ /root/scsi_scan.c	2005-07-06 13:10:30.000000000 -0400=0A=
@@ -163,6 +163,7 @@=0A=
 	{"DELL", "PV660F   PSEUDO",   "*", BLIST_SPARSELUN | =
BLIST_LARGELUN},=0A=
 	{"DELL", "PSEUDO DEVICE .",   "*", BLIST_SPARSELUN | BLIST_LARGELUN}, =
// Dell PV 530F=0A=
 	{"DELL", "PV530F",    "*", BLIST_SPARSELUN | BLIST_LARGELUN}, // Dell =
PV 530F=0A=
+	{"EMC",  "Invista",   "*", BLIST_SPARSELUN | BLIST_LARGELUN}, // EMC =
Invista Product Range =0A=
 	{"EMC", "SYMMETRIX", "*", BLIST_SPARSELUN | BLIST_LARGELUN | =
BLIST_FORCELUN},=0A=
 	{"HP", "A6189A", "*", BLIST_SPARSELUN |  BLIST_LARGELUN}, // HP =
VA7400, by Alar Aun=0A=
 	{"HP", "OPEN-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},	/* HP XP =
Arrays */=0A=

------_=_NextPart_000_01C592B6.0CE1AFB6--
