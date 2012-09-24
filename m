From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/3] Documentation: Add lesb/ to path for LESB attributes in
 FCoE bus documentation
Date: Mon, 24 Sep 2012 11:52:56 -0700
Message-ID: <20120924185256.521.11333.stgit@fritz>
References: <20120924185240.521.22975.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:5680 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757693Ab2IXSw5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Sep 2012 14:52:57 -0400
In-Reply-To: <20120924185240.521.22975.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>

The Link Error Status Block attributes are incorrectly named as they do
not have the lesb_ prefix, but instead are grouped in the lesb/ attribute
group.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-fcoe |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-fcoe b/Documentation/ABI/testing/sysfs-bus-fcoe
index 469d09c..50e2a80 100644
--- a/Documentation/ABI/testing/sysfs-bus-fcoe
+++ b/Documentation/ABI/testing/sysfs-bus-fcoe
@@ -9,19 +9,19 @@ Attributes:
 			  this value will change the dev_loss_tmo for all
 			  FCFs discovered by this controller.
 
-	lesb_link_fail:   Link Error Status Block (LESB) link failure count.
+	lesb/link_fail:   Link Error Status Block (LESB) link failure count.
 
-	lesb_vlink_fail:  Link Error Status Block (LESB) virtual link
+	lesb/vlink_fail:  Link Error Status Block (LESB) virtual link
 			  failure count.
 
-	lesb_miss_fka:    Link Error Status Block (LESB) missed FCoE
+	lesb/miss_fka:    Link Error Status Block (LESB) missed FCoE
 			  Initialization Protocol (FIP) Keep-Alives (FKA).
 
-	lesb_symb_err:    Link Error Status Block (LESB) symbolic error count.
+	lesb/symb_err:    Link Error Status Block (LESB) symbolic error count.
 
-	lesb_err_block:   Link Error Status Block (LESB) block error count.
+	lesb/err_block:   Link Error Status Block (LESB) block error count.
 
-	lesb_fcs_error:   Link Error Status Block (LESB) Fibre Channel
+	lesb/fcs_error:   Link Error Status Block (LESB) Fibre Channel
 			  Serivces error count.
 
 Notes: ctlr_X (global increment starting at 0)

