From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: [PATCH] 2.4.27-rc3
Date: Wed, 21 Jul 2004 14:40:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA204CC68A@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus19.xyratex.com ([65.203.33.19]:34318 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S266746AbUGUVkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2004 17:40:17 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Frank Borich <Frank_Borich@us.xyratex.com>

Add Xyratex 4200 FC-SATA RAID to black list

--- linux-2.4.27-rc3/drivers/scsi/scsi_scan.c   2004-07-13
06:57:48.000000000 -0500
+++ linux-2.4.27-rc3.changed/drivers/scsi/scsi_scan.c   2004-07-13
07:21:22.000000000 -0500
@@ -208,6 +208,7 @@
        {"SMSC", "USB 2 HS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
        {"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
        {"NEC", "iStorage", "*", BLIST_SPARSELUN | BLIST_LARGELUN |
BLIST_FORCELUN},
+       {"Xyratex", "4200", "*", BLIST_SPARSELUN | BLIST_LARGELUN |
BLIST_FORCELUN},

        /*
         * Must be at end of list...


Kind Regards,

Frank Borich
------------------------------------------------------------------
Xyratex Inc.
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
 

