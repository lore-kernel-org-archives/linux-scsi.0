From: Sebastian Herbszt <herbszt@gmx.de>
Subject: [PATCH] libfc: correct function name in comment
Date: Sun, 11 Oct 2015 22:35:18 +0200
Message-ID: <20151011223518.00000bdb@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:64380 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbbJKUfY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Oct 2015 16:35:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Sebastian Herbszt <herbszt@gmx.de>

Use the correct function name in kernel-doc comment.

Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
Acked-by: Vasu Dev <vasu.dev@intel.com>
---

diff -U 5 -rp a/drivers/scsi/libfc/fc_npiv.c b/drivers/scsi/libfc/fc_npiv.c
--- a/drivers/scsi/libfc/fc_npiv.c	2014-09-03 19:30:11.760273300 +0200
+++ b/drivers/scsi/libfc/fc_npiv.c	2015-08-05 00:06:17.927753719 +0200
@@ -23,11 +23,11 @@
 
 #include <scsi/libfc.h>
 #include <linux/export.h>
 
 /**
- * fc_vport_create() - Create a new NPIV vport instance
+ * libfc_vport_create() - Create a new NPIV vport instance
  * @vport: fc_vport structure from scsi_transport_fc
  * @privsize: driver private data size to allocate along with the Scsi_Host
  */
 
 struct fc_lport *libfc_vport_create(struct fc_vport *vport, int privsize)
