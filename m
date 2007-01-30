From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 4/4] aic94xx: Add default bus reset handler
Date: Mon, 29 Jan 2007 23:48:25 -0800
Message-ID: <20070130074825.7612.68070.stgit@elm3a70.beaverton.ibm.com>
References: <20070130074810.7612.31980.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50923 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965430AbXA3Hpx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 02:45:53 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U7jqK3008085
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 02:45:52 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U7jqHY260880
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 02:45:52 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U7jqSB014766
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 02:45:52 -0500
In-Reply-To: <20070130074810.7612.31980.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/aic94xx/aic94xx_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 3aa568f..bc7744e 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -80,6 +80,7 @@ static struct scsi_host_template aic94xx
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_device_reset_handler	= sas_eh_device_reset_handler,
+	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
 };
 
 static int __devinit asd_map_memio(struct asd_ha_struct *asd_ha)
