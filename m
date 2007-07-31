From: Lado <lpenko@gmx.de>
Subject: scsi: fix warning in scsi_sysfs.c
Date: Tue, 31 Jul 2007 23:35:24 +0200
Message-ID: <200707312335.24919.lpenko@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server22.mivitec.net ([213.131.236.1]:47720 "EHLO
	server22.mivitec.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbXGaWUc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 18:20:32 -0400
Received: from [192.168.178.56] (krlh-590f26c9.pool.einsundeins.de [89.15.38.201])
	by server22.mivitec.net (Postfix) with ESMTP id AD294133E19
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 23:47:53 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>

Subject: scsi: fix warning in scsi_sysfs.c

From: Ladislav Penko <lpenko@gmx.de>

change: trivial fix warning (removed unused variable rq)

Signed-off-by: Ladislav Penko <lpenko@gmx.de>

Index: linux/drivers/scsi/scsi_sysfs.c
===================================================================
--- linux.orig/drivers/scsi/scsi_sysfs.c
+++ linux/drivers/scsi/scsi_sysfs.c
@@ -715,7 +715,6 @@ static int attr_add(struct device *dev,
 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
        int error, i;
-       struct request_queue *rq = sdev->request_queue;

        if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
                return error;
