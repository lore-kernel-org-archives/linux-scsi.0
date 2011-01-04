From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [PATCH] scsi_scan.c: fix typo in scsi_sequential_lun_scan()
Date: Mon, 03 Jan 2011 23:02:34 -0200
Message-ID: <1294102954.4193.230.camel@dream>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:58728 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1ADBCm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jan 2011 20:02:42 -0500
Received: from mailhub3.br.ibm.com (mailhub3.br.ibm.com [9.18.232.110])
	by e24smtp02.br.ibm.com (8.14.4/8.13.1) with ESMTP id p041NAiI015902
	for <linux-scsi@vger.kernel.org>; Mon, 3 Jan 2011 23:23:10 -0200
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
	by mailhub3.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p041AE9K3108866
	for <linux-scsi@vger.kernel.org>; Mon, 3 Jan 2011 23:10:14 -0200
Received: from d24av02.br.ibm.com (loopback [127.0.0.1])
	by d24av02.br.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p0412NEj015074
	for <linux-scsi@vger.kernel.org>; Mon, 3 Jan 2011 23:02:23 -0200
Received: from [9.78.133.47] ([9.78.133.47])
	by d24av02.br.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p0412MYN015040
	for <linux-scsi@vger.kernel.org>; Mon, 3 Jan 2011 23:02:22 -0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

Add a missing whitespace to the scsi scan log message.

Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 087821f..3f8cce7 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1157,7 +1157,7 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);

 	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: Sequential scan of"
-				    "%s\n", dev_name(&starget->dev)));
+				    " %s\n", dev_name(&starget->dev)));

 	max_dev_lun = min(max_scsi_luns, shost->max_lun);
 	/*
-- 
1.7.1


