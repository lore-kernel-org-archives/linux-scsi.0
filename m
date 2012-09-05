From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH] fc-transport: Remove unnecessary include
Date: Wed, 05 Sep 2012 13:50:07 -0700
Message-ID: <20120905205007.22949.98001.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40228 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab2IEUuI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Sep 2012 16:50:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com, linux-scsi@vger.kernel.org

This header file is included in user space applications
that are doing "FC Passthrough." This include causes
them to also include scsi/scsi.h. Since this header
file doesn't actually need scsi/scsi.h, remove the
include line.

This patch was tested with 'make allyesconfig'.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---
 include/scsi/scsi_bsg_fc.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/include/scsi/scsi_bsg_fc.h b/include/scsi/scsi_bsg_fc.h
index 91a4e4f..3031b90 100644
--- a/include/scsi/scsi_bsg_fc.h
+++ b/include/scsi/scsi_bsg_fc.h
@@ -26,8 +26,6 @@
  * This file intended to be included by both kernel and user space
  */
 
-#include <scsi/scsi.h>
-
 /*
  * FC Transport SGIO v4 BSG Message Support
  */

