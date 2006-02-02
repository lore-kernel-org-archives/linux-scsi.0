From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 9/9] iscsi update: rm unused sessions list
Date: Wed, 01 Feb 2006 21:07:14 -0600
Message-ID: <1138849634.3456.42.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34484 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1423074AbWBBDHx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2006 22:07:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

rm unused sessions list.

This patch is last becuase I was not sure if this patchset was
going to be applied over the kmalloc2kzalloc one by JesS. If it
is then this patch will not apply and can be dropped for now. I will
resend later when things setttle down.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>



diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 3ebf7f4..2730d50 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -39,10 +39,6 @@ struct iscsi_internal {
 	struct iscsi_transport *iscsi_transport;
 	struct list_head list;
 	/*
-	 * List of sessions for this transport
-	 */
-	struct list_head sessions;
-	/*
 	 * based on transport capabilities, at register time we set these
 	 * bits to tell the transport class it wants attributes displayed
 	 * in sysfs or that it can support different iSCSI Data-Path
@@ -1125,7 +1121,6 @@ iscsi_register_transport(struct iscsi_tr
 	if (!priv)
 		return NULL;
 	INIT_LIST_HEAD(&priv->list);
-	INIT_LIST_HEAD(&priv->sessions);
 	priv->iscsi_transport = tt;
 
 	priv->cdev.class = &iscsi_transport_class;


