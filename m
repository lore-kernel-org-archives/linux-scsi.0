From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: (as284) Add BLIST_INQUIRY_36 to existing blacklist USB
 entries
Date: Tue, 18 May 2004 17:12:07 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0405181709180.933-100000@ida.rowland.org>
References: <20040518123306.A12344@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:29188 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263601AbUERVMH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 May 2004 17:12:07 -0400
In-Reply-To: <20040518123306.A12344@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This is a report of an earlier message that may not have gotten through...

> While I'm at it, this patch is needed to prevent existing blacklist 
> entries from overriding the BLIST_INQUIRY_36 flag for various USB devices.
> 
> Alan Stern



===== drivers/scsi/scsi_devinfo.c 1.7 vs edited =====
--- 1.7/drivers/scsi/scsi_devinfo.c	Wed Mar 17 09:48:00 2004
+++ edited/drivers/scsi/scsi_devinfo.c	Tue May 18 11:58:14 2004
@@ -117,7 +117,7 @@
 	 */
 	{"ADAPTEC", "AACRAID", NULL, BLIST_FORCELUN},
 	{"ADAPTEC", "Adaptec 5400S", NULL, BLIST_FORCELUN},
-	{"BELKIN", "USB 2 HS-CF", "1.95",  BLIST_SPARSELUN},
+	{"BELKIN", "USB 2 HS-CF", "1.95",  BLIST_SPARSELUN | BLIST_INQUIRY_36},
 	{"CANON", "IPUBJD", NULL, BLIST_SPARSELUN},
 	{"CMD", "CRA-7280", NULL, BLIST_SPARSELUN},	/* CMD RAID Controller */
 	{"CNSI", "G7324", NULL, BLIST_SPARSELUN},	/* Chaparral G7324 RAID */
@@ -139,8 +139,8 @@
 	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
 	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
 	{"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN},
-	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN},
+	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN | BLIST_INQUIRY_36},
+	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"HITACHI", "DF400", "*", BLIST_SPARSELUN},
 	{"HITACHI", "DF500", "*", BLIST_SPARSELUN},
 	{"HITACHI", "DF600", "*", BLIST_SPARSELUN},
@@ -174,7 +174,7 @@
 	{"SGI", "RAID3", "*", BLIST_SPARSELUN},
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
 	{"SGI", "TP9100", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN},
+	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN | BLIST_INQUIRY_36},
 	{"SONY", "CD-ROM CDU-8001", NULL, BLIST_BORKEN},
 	{"SONY", "TSL", NULL, BLIST_FORCELUN},		/* DDS3 & DDS4 autoloaders */
 	{"SUN", "T300", "*", BLIST_SPARSELUN},

