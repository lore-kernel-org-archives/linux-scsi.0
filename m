From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/11] libfcoe: fix wrong comment in fcoe_transport_detach
Date: Fri, 01 Apr 2011 16:06:30 -0700
Message-ID: <20110401230630.15001.40264.stgit@localhost6.localdomain6>
References: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab1DAXGa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 19:06:30 -0400
In-Reply-To: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Frank Zhang <frank_1.zhang@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

fix typo of '_attach' -> '_detach' in the comment.

Reported-by: Frank Zhang <frank_1.zhang@intel.com>
Signed-off-by: Yi Zou <yi.zou@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_transport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 538f299..f81f77c 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -335,7 +335,7 @@ out_attach:
 EXPORT_SYMBOL(fcoe_transport_attach);
 
 /**
- * fcoe_transport_attach - Detaches an FCoE transport
+ * fcoe_transport_detach - Detaches an FCoE transport
  * @ft: The fcoe transport to be attached
  *
  * Returns : 0 for success

