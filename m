From: thomas schorpp <t.schorpp@gmx.de>
Subject: [DOC PATCH]  T10/04-262r8
Date: Wed, 09 Nov 2005 16:35:06 +0100
Message-ID: <4372172A.50003@gmx.de>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF4A@WDSCEXBECL03.sc.wdc.com>	<4371BB82.3090208@gmx.de> <4371C557.80807@gmx.de> <4371F7C3.5080702@rtr.ca> <43720232.6090609@gmx.de>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050609020105050205000708"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:38861 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751419AbVKIPfK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2005 10:35:10 -0500
In-Reply-To: <43720232.6090609@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050609020105050205000708
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

thomas schorpp wrote:

> ok, will add the (preliminary) passthrough opcodes to linux/scsi.h, 
> include it in hdparm, add an option "-d atacb", then try it out there, not?
> 

doc patch

Signed-off-by: Thomas Schorpp <t.schorpp@gmx.de>




--------------050609020105050205000708
Content-Type: text/plain;
 name="T10-04-262r8.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="T10-04-262r8.patch"

--- linux-git/include/scsi/scsi.h	2005-11-09 15:38:02.000000000 +0100
+++ linux-2.6-dbg/include/scsi/scsi.h	2005-11-09 15:52:27.000000000 +0100
@@ -116,7 +116,7 @@
 /* values for service action in */
 #define	SAI_READ_CAPACITY_16  0x10
 
-/* Values for T10/04-262r7 */
+/* Values for T10/04-262r8 */
 #define	ATA_16		      0x85	/* 16-byte pass-thru */
 #define	ATA_12		      0xa1	/* 12-byte pass-thru */
 

--------------050609020105050205000708--
