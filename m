From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: [PATCH] 2.4.27-rc1 add device to blacklist
Date: Tue, 22 Jun 2004 14:18:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA204339EB@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus11.xyratex.com ([65.203.33.11]:9809 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S266071AbUFVVSf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jun 2004 17:18:35 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Adds Xyratex FC-SATA RAID to black list


--- scsi_scan.c.OLD     2004-06-21 15:44:48.000000000 -0500
+++ scsi_scan.c 2004-06-21 15:46:16.000000000 -0500
@@ -207,6 +207,7 @@
        {"HP", "C7200", "*", BLIST_SPARSELUN},                  /*
Medium Changer */
        {"SMSC", "USB 2 HS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
        {"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+       {"Xyratex", "4200", "*", BLIST_SPARSELUN | BLIST_LARGELUN |
BLIST_FORCELUN},
        {"NEC", "iStorage", "*", BLIST_SPARSELUN | BLIST_LARGELUN |
BLIST_FORCELUN},

        /*


Thanks!

Frank Borich
------------------------------------------------------------------
Xyratex Inc.
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
 

