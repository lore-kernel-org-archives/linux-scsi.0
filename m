From: Jeremy Higdon <jeremy@sgi.com>
Subject: [PATCH] 2.6.3 - remove some SGI devices from scsi_static_device_list
Date: Tue, 24 Feb 2004 20:09:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040225040907.GA556235@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:60263 "EHLO zok.sgi.com")
	by vger.kernel.org with ESMTP id S262428AbUBYEJI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 23:09:08 -0500
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by zok.sgi.com (8.12.9/8.12.9/linux-outbound_gateway-1.1) with ESMTP id i1P498F6020505
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2004 20:09:08 -0800
Received: from classic.engr.sgi.com (classic.engr.sgi.com [163.154.5.111])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id i1P497aM13923869
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2004 20:09:07 -0800 (PST)
Received: from classic.engr.sgi.com (localhost [127.0.0.1])
	by classic.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id i1P497qa556406
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2004 20:09:07 -0800 (PST)
Received: (from jeremy@localhost)
	by classic.engr.sgi.com (SGI-8.12.5/8.12.5/Submit) id i1P497nu459671
	for linux-scsi@vger.kernel.org; Tue, 24 Feb 2004 20:09:07 -0800 (PST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Some SGI RAID devices identify as being SCSI-3, so they don't need
to be in the scsi_static_device_list any more.  I've tested to make
sure that all luns still show up in a sparse, large config.

So I'm proposing removing them.  Thanks to hch for the suggestion.

jeremy


# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1588.3.1 -> 1.1588.3.2
#	drivers/scsi/scsi_devinfo.c	1.7     -> 1.8    
#
# --------------------------------------------
# 04/02/23	jeremy@tomahawk.engr.sgi.com	1.1588.3.2
# Remove SGI TP9300, TP9400, and TP9500.  They advertise as SCSI-3, so they
# don't need to be on the device list.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c	Tue Feb 24 20:03:48 2004
+++ b/drivers/scsi/scsi_devinfo.c	Tue Feb 24 20:03:48 2004
@@ -178,9 +178,6 @@
 	{"SGI", "RAID3", "*", BLIST_SPARSELUN},
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
 	{"SGI", "TP9100", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"SGI", "TP9300", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"SGI", "TP9400", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"SGI", "TP9500", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"MYLEX", "DACARMRB", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{ NULL, NULL, NULL, 0 },
