From: Cyril Plisko <Cyril.Plisko@CloverleafComm.COM>
Subject: Patches to add support for Cloverleaf SCSI devices
Date: Thu, 19 Feb 2004 15:09:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200402191509.41289.Cyril.Plisko@CloverleafComm.COM>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_VWLNAVYAAAHqDAA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.cloverleafcomm.com ([212.179.48.177]:48053 "EHLO
	mail.clf.com") by vger.kernel.org with ESMTP id S267246AbUBSNJq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2004 08:09:46 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--Boundary-00=_VWLNAVYAAAHqDAA
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

Attached are patches for linux-2.4 and -2.6 series to add support
for Cloverleaf SCSI devices.

Please integrate them.

Regards,
	Cyril


-- 
/~\  The ASCII Ribbon Campaign
\ /    No HTML/RTF in email
 X     No Word docs in email
/ \  Respect for open standards

--Boundary-00=_VWLNAVYAAAHqDAA
Content-Type: text/x-diff;
  charset="us-ascii";
  name="cllf-linux-2.4.24.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cllf-linux-2.4.24.patch"

--- drivers/scsi/scsi_scan.c.orig	Thu Feb 19 15:02:49 2004
+++ drivers/scsi/scsi_scan.c	Thu Feb 19 15:03:22 2004
@@ -206,6 +206,7 @@
 	{"SMSC", "USB 2 HS", "*", BLIST_SPARSELUN | BLIST_LARGELUN}, 
 	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"NEC", "iStorage", "*", BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
+	{"CLOVERLF", "CLOVERLEAF", "*", BLIST_SPARSELUN},
 
 	/*
 	 * Must be at end of list...

--Boundary-00=_VWLNAVYAAAHqDAA
Content-Type: text/x-diff;
  charset="us-ascii";
  name="cllf-linux-2.6.3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cllf-linux-2.6.3.patch"

--- drivers/scsi/scsi_devinfo.c.orig	Wed Feb 18 14:21:18 2004
+++ drivers/scsi/scsi_devinfo.c	Wed Feb 18 14:21:55 2004
@@ -183,6 +183,7 @@
 	{"SGI", "TP9500", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"MYLEX", "DACARMRB", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"CLOVERLF", "CLOVERLEAF", "*", BLIST_SPARSELUN},
 	{ NULL, NULL, NULL, 0 },
 };
 

--Boundary-00=_VWLNAVYAAAHqDAA--

