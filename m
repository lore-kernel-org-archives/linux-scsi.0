From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] SCSI: delete outdated comment in API reference
Date: Wed, 27 Jun 2007 02:45:39 +0200 (CEST)
Message-ID: <tkrat.3ba1cc1659bf7af1@s5r6.in-berlin.de>
References: <319583.29876.qm@web31809.mail.mud.yahoo.com>
 <4680EDFE.4050808@s5r6.in-berlin.de>
 <1182867615.3562.3.camel@localhost.localdomain>
 <4681351F.8000403@s5r6.in-berlin.de>
 <1182877289.3562.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:36958 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbXF0Ap5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jun 2007 20:45:57 -0400
In-Reply-To: <1182877289.3562.27.camel@localhost.localdomain>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

and move a comment on scsi_target<->scsi_device relationship to a more
appropriate place.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 include/scsi/scsi_device.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux/include/scsi/scsi_device.h
===================================================================
--- linux.orig/include/scsi/scsi_device.h
+++ linux/include/scsi/scsi_device.h
@@ -84,7 +84,7 @@ struct scsi_device {
 	const char * model;		/* ... after scan; point to static string */
 	const char * rev;		/* ... "nullnullnullnull" before scan */
 	unsigned char current_tag;	/* current tag */
-	struct scsi_target      *sdev_target;   /* used only for single_lun */
+	struct scsi_target      *sdev_target;
 
 	unsigned int	sdev_bflags; /* black/white flags as also found in
 				 * scsi_devinfo.[hc]. For now used only to
@@ -168,12 +168,12 @@ enum scsi_target_state {
 };
 
 /*
- * scsi_target: representation of a scsi target, for now, this is only
- * used for single_lun devices. If no one has active IO to the target,
- * starget_sdev_user is NULL, else it points to the active sdev.
+ * scsi_target: representation of a scsi target
  */
 struct scsi_target {
-	struct scsi_device	*starget_sdev_user;
+	struct scsi_device	*starget_sdev_user;  /* For now, this is only
+	 * used for single_lun devices. If no one has active IO to the target,
+	 * starget_sdev_user is NULL, else it points to the active sdev. */
 	struct list_head	siblings;
 	struct list_head	devices;
 	struct device		dev;

-- 
Stefan Richter
-=====-=-=== -==- ==-==
http://arcgraph.de/sr/

