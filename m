From: Franco Borich <fran2170@comcast.net>
Subject: [PATCH] 2.4.27-rc1 add device to scsi_scan.c blacklist
Date: Thu, 24 Jun 2004 10:04:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40DAED7E.6020202@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc11.comcast.net ([204.127.202.55]:36031 "EHLO
	sccrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S265399AbUFXPDG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jun 2004 11:03:06 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Adds Xyratex 4200 FC-SATA RAID to blacklist.  Posting again due to 
mailer problems.

--- scsi_scan.c.OLD     2004-06-21 15:44:48.000000000 -0500
+++ scsi_scan.c 2004-06-21 15:46:16.000000000 -0500
@@ -207,6 +207,7 @@
       {"HP", "C7200", "*", BLIST_SPARSELUN},                  /* Medium 
Changer */
       {"SMSC", "USB 2 HS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
       {"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+       {"Xyratex", "4200", "*", BLIST_SPARSELUN | BLIST_LARGELUN | 
BLIST_FORCELUN},
       {"NEC", "iStorage", "*", BLIST_SPARSELUN | BLIST_LARGELUN | 
BLIST_FORCELUN},

       /*

Thanks!

Frank Borich
Xyratex International Ltd.
(630)654-6089



