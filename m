From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: [PATCH] 2.4.27-pre6 add device to scsi_scan.c blacklist
Date: Fri, 18 Jun 2004 10:23:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA20433908@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus11.xyratex.com ([65.203.33.11]:35930 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S266254AbUFRRXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2004 13:23:41 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi,

Adds Xyratex 4200 FC-SATA RAID controller to blacklist.


--- scsi_scan.c.OLD     2004-06-18 09:55:39.000000000 -0500
+++ scsi_scan.c 2004-06-18 10:57:21.000000000 -0500
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


Thanks,

Frank Borich
------------------------------------------------------------------
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
 

