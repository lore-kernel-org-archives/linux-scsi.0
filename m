From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: [PATCH] 2.4.27 add device to scsi_scan.c's blacklist
Date: Wed, 11 Aug 2004 12:57:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA204CCC5F@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus11.xyratex.com ([65.203.33.11]:4198 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S268194AbUHKT5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Aug 2004 15:57:16 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Marcelo Tosatti <marcelo.tosatti@cyclades.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: David Lethe <David_Lethe@us.xyratex.com>


Hi,

I have submitted this patch several times to the 2.4.x tree.  It keeps
getting dropped silently.  This is my first time submitting a patch,
so can someone kindly let me know if I am doing something wrong? I have
followed the instructions at
http://www.kernel.org/pub/linux/docs/lkml/#s4-1.  
Any advice would be greatly appreciated.  The patch simply adds our
FC-SATA 
RAID to scsi_scan.c's blacklist.  


--- linux-2.4.27/drivers/scsi/scsi_scan.c       2004-08-11
14:42:12.000000000 -0500
+++ linux-2.4.27.changed/drivers/scsi/scsi_scan.c       2004-08-11
14:43:34.000000000 -0500
@@ -208,6 +208,7 @@
        {"SMSC", "USB 2 HS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
        {"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
        {"NEC", "iStorage", "*", BLIST_SPARSELUN | BLIST_LARGELUN |
BLIST_FORCELUN},
+       {"Xyratex", "4200", "*", BLIST_SPARSELUN | BLIST_LARGELUN},

        /*
         * Must be at end of list...


Thanks in Advance,

Frank Borich
------------------------------------------------------------------
Xyratex Inc.
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
 

