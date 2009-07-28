From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 6/6] RFC: beiscsi: modified MAINTAINERS
Date: Tue, 28 Jul 2009 12:48:53 +0530
Message-ID: <20090728071844.GA13707@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:47662 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750722AbZG1HSj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jul 2009 03:18:39 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jayamohank@serverengines.com

 The modified MAINTAINERS file for  adding beiscsi driver

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ebc2691..9bd8a71 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5253,6 +5253,14 @@ W:	http://www.serverengines.com
 S:	Supported
 F:	drivers/net/benet/
 
+SERVER ENGINES 10Gbps iSCSI - BladeEngine 2 DRIVER
+P:	Jayamohan Kallickal
+M:	jayamohank@serverengines.com
+L:	linux-scsi@vger.kernel.org
+W:	http://www.serverengines.com
+S:	Supported
+F:	drivers/scsi/beiscsi/
+
 SFC NETWORK DRIVER
 P:	Steve Hodgson
 P:	Ben Hutchings
-- 
1.6.3

