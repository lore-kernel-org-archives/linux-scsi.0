From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 8/8] be2iscsi: modified MAINTAINERS
Date: Sat, 5 Sep 2009 07:41:07 +0530
Message-ID: <20090905021058.GA12453@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:51691 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S934567AbZIECLE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2009 22:11:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

The modified MAINTAINERS file for  adding be2iscsi driver

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 60299a9..4299f6b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4518,6 +4518,14 @@ F:	drivers/ata/
 F:	include/linux/ata.h
 F:	include/linux/libata.h
 
+SERVER ENGINES 10Gbps iSCSI - BladeEngine 2 DRIVER
+P:     Jayamohan Kallickal
+M:     jayamohank@serverengines.com
+L:     linux-scsi@vger.kernel.org
+W:     http://www.serverengines.com
+S:     Supported
+F:     drivers/scsi/be2iscsi/
+
 SERVER ENGINES 10Gbps NIC - BladeEngine 2 DRIVER
 M:	Sathya Perla <sathyap@serverengines.com>
 M:	Subbu Seetharaman <subbus@serverengines.com>
-- 
1.6.4

