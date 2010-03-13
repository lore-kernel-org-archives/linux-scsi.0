From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/16] libfc: add definition for task attribute mask
Date: Fri, 12 Mar 2010 16:07:41 -0800
Message-ID: <20100313000741.22251.41324.stgit@localhost.localdomain>
References: <20100313000730.22251.54662.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34792 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932782Ab0CMAHm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 19:07:42 -0500
In-Reply-To: <20100313000730.22251.54662.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The FCP command header definition should define a mask for
the task attribute field.  This adds that #define.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 include/scsi/fc/fc_fcp.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/scsi/fc/fc_fcp.h b/include/scsi/fc/fc_fcp.h
index 747e2c7..8e9b222 100644
--- a/include/scsi/fc/fc_fcp.h
+++ b/include/scsi/fc/fc_fcp.h
@@ -76,6 +76,7 @@ struct fcp_cmnd32 {
 #define	FCP_PTA_HEADQ	    1	/* head of queue task attribute */
 #define	FCP_PTA_ORDERED     2	/* ordered task attribute */
 #define	FCP_PTA_ACA	    4	/* auto. contigent allegiance */
+#define	FCP_PTA_MASK	    7	/* mask for task attribute field */
 #define	FCP_PRI_SHIFT	    3	/* priority field starts in bit 3 */
 #define	FCP_PRI_RESVD_MASK  0x80	/* reserved bits in priority field */
 

