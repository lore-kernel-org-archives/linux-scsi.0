Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4DCC6FA8A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Sep 2022 02:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiIMChc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Sep 2022 22:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiIMCh3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Sep 2022 22:37:29 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE75E014;
        Mon, 12 Sep 2022 19:37:26 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MRSGr2xhXznVFV;
        Tue, 13 Sep 2022 10:34:44 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 13 Sep 2022 10:37:23 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <andrew.vasquez@qlogic.com>, <James.Bottomley@SteelEye.com>,
        <giridhar.malavali@qlogic.com>, <James.Bottomley@suse.de>,
        <James.Bottomley@HansenPartnership.com>, <quinn.tran@cavium.com>,
        <himanshu.madhani@cavium.com>, <bart.vanassche@sandisk.com>,
        <nab@linux-iscsi.org>, <cuigaosheng1@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: [PATCH 1/2] scsi: qla2xxx: remove unused declarations for qla2xxx
Date:   Tue, 13 Sep 2022 10:37:21 +0800
Message-ID: <20220913023722.547249-2-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220913023722.547249-1-cuigaosheng1@huawei.com>
References: <20220913023722.547249-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qla2x00_get_fw_version_str() has been removed since
commit abbd8870b9cb ("[SCSI] qla2xxx: Factor-out ISP specific
functions to method-based call tables.").

qla2x00_release_nvram_protection() has been removed since
commit 459c537807bd ("[SCSI] qla2xxx: Add ISP24xx
flash-manipulation routines.").

qla82xx_rdmem() and qla82xx_wrmem() have been removed since
commit 3711333dfbee ("[SCSI] qla2xxx: Updates for ISP82xx.").

qla25xx_rd_req_reg(), qla24xx_rd_req_reg(), qla25xx_wrt_rsp_reg(),
qla24xx_wrt_rsp_reg(), qla25xx_wrt_req_reg() and qla24xx_wrt_req_reg()
have been removed since commit 08029990b25b ("[SCSI] qla2xxx: Refactor
request/response-queue register handling.").

qla2x00_async_login_done() has been removed since
commit 726b85487067 ("qla2xxx: Add framework for async fabric discovery").

qlt_24xx_process_response_error() has been removed since
commit c5419e2618b9 ("scsi: qla2xxx: Combine Active command arrays.").

So remove the declarations for them from header file.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h    | 12 ------------
 drivers/scsi/qla2xxx/qla_target.h |  2 --
 2 files changed, 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 2fc280e61306..e3256e721be1 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -70,8 +70,6 @@ extern int qla2x00_async_prlo(struct scsi_qla_host *, fc_port_t *);
 extern int qla2x00_async_adisc(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern int qla2x00_async_tm_cmd(fc_port_t *, uint32_t, uint32_t, uint32_t);
-extern void qla2x00_async_login_done(struct scsi_qla_host *, fc_port_t *,
-    uint16_t *);
 struct qla_work_evt *qla2x00_alloc_work(struct scsi_qla_host *,
     enum qla_work_type);
 extern int qla24xx_async_gnl(struct scsi_qla_host *, fc_port_t *);
@@ -278,7 +276,6 @@ extern int qla24xx_vport_create_req_sanity_check(struct fc_vport *);
 extern scsi_qla_host_t *qla24xx_create_vhost(struct fc_vport *);
 
 extern void qla2x00_sp_free_dma(srb_t *sp);
-extern char *qla2x00_get_fw_version_str(struct scsi_qla_host *, char *);
 
 extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int);
 extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *);
@@ -615,7 +612,6 @@ void __qla_consume_iocb(struct scsi_qla_host *vha, void **pkt, struct rsp_que **
 /*
  * Global Function Prototypes in qla_sup.c source file.
  */
-extern void qla2x00_release_nvram_protection(scsi_qla_host_t *);
 extern int qla24xx_read_flash_data(scsi_qla_host_t *, uint32_t *,
     uint32_t, uint32_t);
 extern uint8_t *qla2x00_read_nvram_data(scsi_qla_host_t *, void *, uint32_t,
@@ -787,12 +783,6 @@ extern void qla2x00_init_response_q_entries(struct rsp_que *);
 extern int qla25xx_delete_req_que(struct scsi_qla_host *, struct req_que *);
 extern int qla25xx_delete_rsp_que(struct scsi_qla_host *, struct rsp_que *);
 extern int qla25xx_delete_queues(struct scsi_qla_host *);
-extern uint16_t qla24xx_rd_req_reg(struct qla_hw_data *, uint16_t);
-extern uint16_t qla25xx_rd_req_reg(struct qla_hw_data *, uint16_t);
-extern void qla24xx_wrt_req_reg(struct qla_hw_data *, uint16_t, uint16_t);
-extern void qla25xx_wrt_req_reg(struct qla_hw_data *, uint16_t, uint16_t);
-extern void qla25xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
-extern void qla24xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
 
 /* qlafx00 related functions */
 extern int qlafx00_pci_config(struct scsi_qla_host *);
@@ -877,8 +867,6 @@ extern void qla82xx_init_flags(struct qla_hw_data *);
 extern void qla82xx_set_drv_active(scsi_qla_host_t *);
 extern int qla82xx_wr_32(struct qla_hw_data *, ulong, u32);
 extern int qla82xx_rd_32(struct qla_hw_data *, ulong);
-extern int qla82xx_rdmem(struct qla_hw_data *, u64, void *, int);
-extern int qla82xx_wrmem(struct qla_hw_data *, u64, void *, int);
 
 /* ISP 8021 IDC */
 extern void qla82xx_clear_drv_active(struct qla_hw_data *);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 080c46eb8245..7df86578214f 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1075,8 +1075,6 @@ extern void qlt_81xx_config_nvram_stage2(struct scsi_qla_host *,
 	struct init_cb_81xx *);
 extern void qlt_81xx_config_nvram_stage1(struct scsi_qla_host *,
 	struct nvram_81xx *);
-extern int qlt_24xx_process_response_error(struct scsi_qla_host *,
-	struct sts_entry_24xx *);
 extern void qlt_modify_vp_config(struct scsi_qla_host *,
 	struct vp_config_entry_24xx *);
 extern void qlt_probe_one_stage1(struct scsi_qla_host *, struct qla_hw_data *);
-- 
2.25.1

