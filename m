Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70F9C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 12:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94A1461A1F
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 12:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhCYMaG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 08:30:06 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14592 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbhCYM3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 08:29:34 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F5krg5PKnz19HC2;
        Thu, 25 Mar 2021 20:27:31 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.498.0; Thu, 25 Mar 2021
 20:29:23 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>, <yanaijie@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <luojiaxing@huawei.com>, <chenxiang66@hisilicon.com>,
        <linuxarm@openeuler.org>
Subject: [PATCH v1 2/2] scsi: libsas: clean up for white spaces
Date:   Thu, 25 Mar 2021 20:29:56 +0800
Message-ID: <1616675396-6108-3-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616675396-6108-1-git-send-email-luojiaxing@huawei.com>
References: <1616675396-6108-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some checkpatch errors are found that some white spaces are missing or
being used inappropriately. So fix them all.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/scsi/libsas/sas_discover.c |  2 +-
 drivers/scsi/libsas/sas_expander.c | 15 ++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 4a39848..3692817 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -75,7 +75,7 @@ static int sas_get_port_device(struct asd_sas_port *port)
 		struct dev_to_host_fis *fis =
 			(struct dev_to_host_fis *) dev->frame_rcvd;
 		if (fis->interrupt_reason == 1 && fis->lbal == 1 &&
-		    fis->byte_count_low==0x69 && fis->byte_count_high == 0x96
+		    fis->byte_count_low == 0x69 && fis->byte_count_high == 0x96
 		    && (fis->device & ~0x10) == 0)
 			dev->dev_type = SAS_SATA_PM;
 		else
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index ebb55e4..fc6b9d8 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -553,7 +553,7 @@ static int sas_ex_manuf_info(struct domain_device *dev)
 
 	mi_req[1] = SMP_REPORT_MANUF_INFO;
 
-	res = smp_execute_task(dev, mi_req, MI_REQ_SIZE, mi_resp,MI_RESP_SIZE);
+	res = smp_execute_task(dev, mi_req, MI_REQ_SIZE, mi_resp, MI_RESP_SIZE);
 	if (res) {
 		pr_notice("MI: ex %016llx failed:0x%x\n",
 			  SAS_ADDR(dev->sas_addr), res);
@@ -594,13 +594,13 @@ int sas_smp_phy_control(struct domain_device *dev, int phy_id,
 
 	pc_req[1] = SMP_PHY_CONTROL;
 	pc_req[9] = phy_id;
-	pc_req[10]= phy_func;
+	pc_req[10] = phy_func;
 	if (rates) {
 		pc_req[32] = rates->minimum_linkrate << 4;
 		pc_req[33] = rates->maximum_linkrate << 4;
 	}
 
-	res = smp_execute_task(dev, pc_req, PC_REQ_SIZE, pc_resp,PC_RESP_SIZE);
+	res = smp_execute_task(dev, pc_req, PC_REQ_SIZE, pc_resp, PC_RESP_SIZE);
 	if (res) {
 		pr_err("ex %016llx phy%02d PHY control failed: %d\n",
 		       SAS_ADDR(dev->sas_addr), phy_id, res);
@@ -678,7 +678,7 @@ int sas_smp_get_phy_events(struct sas_phy *phy)
 	req[9] = phy->number;
 
 	res = smp_execute_task(dev, req, RPEL_REQ_SIZE,
-			            resp, RPEL_RESP_SIZE);
+			       resp, RPEL_RESP_SIZE);
 
 	if (res)
 		goto out;
@@ -714,7 +714,7 @@ int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
 	rps_req[9] = phy_id;
 
 	res = smp_execute_task(dev, rps_req, RPS_REQ_SIZE,
-			            rps_resp, RPS_RESP_SIZE);
+			       rps_resp, RPS_RESP_SIZE);
 
 	/* 0x34 is the FIS type for the D2H fis.  There's a potential
 	 * standards cockup here.  sas-2 explicitly specifies the FIS
@@ -1117,7 +1117,7 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
 			 */
 			if (SAS_ADDR(ex->ex_phy[i].attached_sas_addr) ==
 			    SAS_ADDR(child->sas_addr)) {
-				ex->ex_phy[i].phy_state= PHY_DEVICE_DISCOVERED;
+				ex->ex_phy[i].phy_state = PHY_DEVICE_DISCOVERED;
 				if (sas_ex_join_wide_port(dev, i))
 					pr_debug("Attaching ex phy%02d to wide port %016llx\n",
 						 i, SAS_ADDR(ex->ex_phy[i].attached_sas_addr));
@@ -1533,7 +1533,8 @@ static int sas_configure_phy(struct domain_device *dev, int phy_id,
 	if (res)
 		return res;
 	if (include ^ present)
-		return sas_configure_set(dev, phy_id, sas_addr, index,include);
+		return sas_configure_set(dev, phy_id, sas_addr, index,
+					 include);
 
 	return res;
 }
-- 
2.7.4

