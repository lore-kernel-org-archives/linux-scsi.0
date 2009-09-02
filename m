From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 8/8] be2iscsi: modified MAINTAINERS
Date: Wed, 2 Sep 2009 09:44:43 +0530
Message-ID: <20090902041434.GA19400@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:33823 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752452AbZIBEOb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 00:14:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The modified MAINTAINERS file for  adding be2iscsi driver

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 60299a9..d0ac132 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4526,6 +4526,14 @@ W:	http://www.serverengines.com
 S:	Supported
 F:	drivers/net/benet/
 
+SERVER ENGINES 10Gbps iSCSI - BladeEngine 2 DRIVER
+P:     Jayamohan Kallickal
+M:     jayamohank@serverengines.com
+L:     linux-scsi@vger.kernel.org
+W:     http://www.serverengines.com
+S:     Supported
+F:     drivers/scsi/be2iscsi/
+ 
 SFC NETWORK DRIVER
 P:	Steve Hodgson
 P:	Ben Hutchings
-- 
1.6.4

