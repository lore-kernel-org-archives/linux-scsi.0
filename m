From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3/4] isci: make function declaration match implementation
Date: Wed, 11 Jul 2012 14:59:39 -0700
Message-ID: <20120711215939.26813.24956.stgit@dwillia2-linux.jf.intel.com>
References: <20120711215901.26813.19955.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39079 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab2GKVnK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2012 17:43:10 -0400
In-Reply-To: <20120711215901.26813.19955.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

Sparse complains that we redeclare this with a different type, because
in the .c file we use an enum and in the .h file we declare the
parameter as a u32.  Probably it's best to use an enum in both places.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/remote_node_context.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/remote_node_context.h b/drivers/scsi/isci/remote_node_context.h
index a703b9c..c7ee81d 100644
--- a/drivers/scsi/isci/remote_node_context.h
+++ b/drivers/scsi/isci/remote_node_context.h
@@ -212,7 +212,7 @@ enum sci_status sci_remote_node_context_destruct(struct sci_remote_node_context
 						      scics_sds_remote_node_context_callback callback,
 						      void *callback_parameter);
 enum sci_status sci_remote_node_context_suspend(struct sci_remote_node_context *sci_rnc,
-						     u32 suspend_type,
+						     enum sci_remote_node_suspension_reasons reason,
 						     u32 suspension_code);
 enum sci_status sci_remote_node_context_resume(struct sci_remote_node_context *sci_rnc,
 						    scics_sds_remote_node_context_callback cb_fn,

