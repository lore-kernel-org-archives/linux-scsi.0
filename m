From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] isci: make function declaration match implementation
Date: Tue, 27 Mar 2012 10:16:14 +0300
Message-ID: <20120327071614.GB19008@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:44894 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2C0HQ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Mar 2012 03:16:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

Sparse complains that we redeclare this with a different type, because
in the .c file we use an enum and in the .h file we declare the
parameter as a u32.  Probably it's best to use an enum in both places.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/isci/remote_node_context.h b/drivers/scsi/isci/remote_node_context.h
index a703b9c..1177204 100644
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
