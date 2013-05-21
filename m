From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 4/4] MAINTAINERS: Fix fcoe mailing list
Date: Tue, 21 May 2013 10:44:51 -0700
Message-ID: <20130521174450.3033.76201.stgit@fritz>
References: <20130521174426.3033.16298.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2598 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab3EURpJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 May 2013 13:45:09 -0400
In-Reply-To: <20130521174426.3033.16298.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>

From: Neil Horman <nhorman@tuxdriver.com>

The FCoE mailing list has moved, updte it in the MAINTAINERS file
Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Robert Love <robert.w.love@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8bdd7a7..bde678d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3165,7 +3165,7 @@ F:	lib/fault-inject.c
 
 FCOE SUBSYSTEM (libfc, libfcoe, fcoe)
 M:	Robert Love <robert.w.love@intel.com>
-L:	devel@open-fcoe.org
+L:	fcoe-devel@open-fcoe.org
 W:	www.Open-FCoE.org
 S:	Supported
 F:	drivers/scsi/libfc/

