From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 6/7] aic94xx: Register eh_device_reset_handler
Date: Fri, 26 Jan 2007 14:08:55 -0800
Message-ID: <20070126220855.20198.22311.stgit@elm3a70.beaverton.ibm.com>
References: <20070126220834.20198.21100.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47792 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965392AbXAZWHE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jan 2007 17:07:04 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0QM72qe032170
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:07:02 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0QM72WB079760
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:07:02 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0QM72hg003204
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:07:02 -0500
In-Reply-To: <20070126220834.20198.21100.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Register libsas's default device reset code with the scsi.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/aic94xx/aic94xx_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index a6fb33f..a018fb0 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -79,6 +79,7 @@ static struct scsi_host_template aic94xx
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.eh_device_reset_handler	= sas_eh_device_reset_handler,
 };
 
 static int __devinit asd_map_memio(struct asd_ha_struct *asd_ha)
