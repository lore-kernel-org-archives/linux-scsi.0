From: Neerav Parikh <neerav.parikh@intel.com>
Subject: [PATCH 2/6] scsi_transport_fc: Getting FC Port Speed in sync with
 FC-GS
Date: Sun, 22 Jan 2012 17:29:55 -0800
Message-ID: <20120123012955.923.19004.stgit@localhost6.localdomain6>
References: <20120123012944.923.63220.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25322 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab2AWBlI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jan 2012 20:41:08 -0500
In-Reply-To: <20120123012944.923.63220.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, james.smart@emulex.com, devel@open-fcoe.org

The values for the 4G and 10G speeds are not in sync with
definitions in SM-HBA/FC-GS-x/etc.
This patch brings them in sync to these specifications.

The values are converted to strings when represented via
sysfs attribute, hence that should cover for user space
apps as they may not see any change.

Signed-off-by: Neerav Parikh <neerav.parikh@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Acked-by: Robert Love <robert.w.love@intel.com>
---
 include/scsi/scsi_transport_fc.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 0135cbc..719faf1 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -126,8 +126,8 @@ enum fc_vport_state {
 					     incapable of reporting */
 #define FC_PORTSPEED_1GBIT		1
 #define FC_PORTSPEED_2GBIT		2
-#define FC_PORTSPEED_4GBIT		4
-#define FC_PORTSPEED_10GBIT		8
+#define FC_PORTSPEED_10GBIT		4
+#define FC_PORTSPEED_4GBIT		8
 #define FC_PORTSPEED_8GBIT		0x10
 #define FC_PORTSPEED_16GBIT		0x20
 #define FC_PORTSPEED_NOT_NEGOTIATED	(1 << 15) /* Speed not established */

