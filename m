From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic94xx: remove local_attached flag
Date: Fri, 25 Aug 2006 14:12:01 -0500
Message-ID: <1156533121.3462.15.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:35780 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751475AbWHYTME (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Aug 2006 15:12:04 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k7PJC2530407
	for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2006 15:12:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Follows the transport class removal

James

Index: BUILD-2.6/drivers/scsi/libsas/sas_expander.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_expander.c	2006-08-25 13:38:00.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_expander.c	2006-08-25 13:38:20.000000000 -0500
@@ -183,9 +183,6 @@
 	phy->virtual = dr->virtual;
 	phy->last_da_index = -1;
 
-	/* FIXME: This probably isn't right, but it will do for now*/
-	phy->phy->local_attached = 1;
-
 	phy->phy->identify.initiator_port_protocols = phy->attached_iproto;
 	phy->phy->identify.target_port_protocols = phy->attached_tproto;
 	phy->phy->identify.phy_identifier = phy_id;
Index: BUILD-2.6/drivers/scsi/libsas/sas_phy.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_phy.c	2006-08-25 13:38:05.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_phy.c	2006-08-25 13:38:26.000000000 -0500
@@ -139,7 +139,6 @@
 		if (!phy->phy)
 			return -ENOMEM;
 
-		phy->phy->local_attached = 1;
 		phy->phy->identify.initiator_port_protocols =
 			phy->iproto;
 		phy->phy->identify.target_port_protocols = phy->tproto;


