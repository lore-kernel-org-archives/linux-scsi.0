From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/16] Documentation: Add missing devices/ to devices path
Date: Wed, 12 Dec 2012 15:22:14 -0800
Message-ID: <20121212232214.13084.22497.stgit@fritz>
References: <20121212232203.13084.3630.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49889 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab2LLXWS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Dec 2012 18:22:18 -0500
In-Reply-To: <20121212232203.13084.3630.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>

Add missing 'devices/ subdirectory to /sys/bus/fcoe/devices/ctlr_X
and /sys/bus/fcoe/devices/fcf_X references.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-fcoe |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-fcoe b/Documentation/ABI/testing/sysfs-bus-fcoe
index 50e2a80..971dc22 100644
--- a/Documentation/ABI/testing/sysfs-bus-fcoe
+++ b/Documentation/ABI/testing/sysfs-bus-fcoe
@@ -1,4 +1,4 @@
-What:		/sys/bus/fcoe/ctlr_X
+What:		/sys/bus/fcoe/devices/ctlr_X
 Date:		March 2012
 KernelVersion:	TBD
 Contact:	Robert Love <robert.w.love@intel.com>, devel@open-fcoe.org
@@ -26,7 +26,7 @@ Attributes:
 
 Notes: ctlr_X (global increment starting at 0)
 
-What:		/sys/bus/fcoe/fcf_X
+What:		/sys/bus/fcoe/devices/fcf_X
 Date:		March 2012
 KernelVersion:	TBD
 Contact:	Robert Love <robert.w.love@intel.com>, devel@open-fcoe.org

