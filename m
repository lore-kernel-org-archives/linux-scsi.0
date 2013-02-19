From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/21] Documentation: Add missing devices/ to devices path
Date: Tue, 19 Feb 2013 11:30:42 -0800
Message-ID: <20130219193042.10192.73166.stgit@fritz>
References: <20130219193031.10192.33777.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8036 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933237Ab3BSTa6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2013 14:30:58 -0500
In-Reply-To: <20130219193031.10192.33777.stgit@fritz>
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

