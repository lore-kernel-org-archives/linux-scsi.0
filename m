From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 6/6] RFC: beiscsi: modified MAINTAINERS
Date: Thu, 13 Aug 2009 12:43:24 +0530
Message-ID: <20090813071314.GA29165@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:59651 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753312AbZHMHNQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Aug 2009 03:13:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The modified MAINTAINERS file for  adding beiscsi driver

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 MAINTAINERS |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b1114cf..662d028 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4512,7 +4512,15 @@ W:	http://www.serverengines.com
 S:	Supported
 F:	drivers/net/benet/
 
-SFC NETWORK DRIVER
+SERVER ENGINES 10Gbps iSCSI - BladeEngine 2 DRIVER
+P:      Jayamohan Kallickal
+M:      jayamohank@serverengines.com
+L:      linux-scsi@vger.kernel.org
+W:      http://www.serverengines.com
+S:      Supported
+F:      drivers/scsi/beiscsi/
+
+
 P:	Steve Hodgson
 P:	Ben Hutchings
 M:	Robert Stonehouse <linux-net-drivers@solarflare.com>
-- 
1.6.3

