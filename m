From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] scsi_sysfs: use NULL instead of 0
Date: Sun, 27 Mar 2005 21:40:12 -0800
Message-ID: <20050327214012.353a47fa.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:20195 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261165AbVC1Fqm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 00:46:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>


drivers/scsi/scsi_sysfs.c:814:66: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <rddunlap@osdl.org>

diffstat:=
 drivers/scsi/scsi_sysfs.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -Naurp ./drivers/scsi/scsi_sysfs.c~scsi_sysfs_null ./drivers/scsi/scsi_sysfs.c
--- ./drivers/scsi/scsi_sysfs.c~scsi_sysfs_null	2005-03-26 21:48:11.000000000 -0800
+++ ./drivers/scsi/scsi_sysfs.c	2005-03-27 21:03:53.000000000 -0800
@@ -811,4 +811,4 @@ EXPORT_SYMBOL(scsi_is_sdev_device);
 
 /* A blank transport template that is used in drivers that don't
  * yet implement Transport Attributes */
-struct scsi_transport_template blank_transport_template = { { { {0, }, }, }, };
+struct scsi_transport_template blank_transport_template = { { { {NULL, }, }, }, };


---
