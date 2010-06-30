From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 10/12] be2iscsi: patch from Randy Dunlap
Date: Wed, 30 Jun 2010 05:33:21 +0530
Message-ID: <20100630000310.GA20370@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:34823 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755312Ab0F3ADM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2010 20:03:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

  This patch add NET because be2iscsi is using sysfs_format_mac function
  Found and patch originally submitted by Randy Dunlap

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com> 
Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 978a57d..f5106df 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -23,6 +23,7 @@
 
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/if_ether.h>
 #include <linux/in.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
-- 
1.6.5.2

