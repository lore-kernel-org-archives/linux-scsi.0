Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406E4C001E0
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 13:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245380AbjHPNJV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 09:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243351AbjHPNIr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 09:08:47 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EC41BFB
        for <linux-scsi@vger.kernel.org>; Wed, 16 Aug 2023 06:08:45 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RQpKP5l5vzFqcj;
        Wed, 16 Aug 2023 21:05:45 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Wed, 16 Aug
 2023 21:08:43 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <qutran@marvell.com>
CC:     <linux-scsi@vger.kernel.org>, <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: qla2xxx: Remove unused declarations
Date:   Wed, 16 Aug 2023 21:08:42 +0800
Message-ID: <20230816130842.16684-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These declarations are not used anymore, remove it.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 33fba9d62969..816c0b9ecd0e 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -48,8 +48,6 @@ extern int qla24xx_els_dcmd2_iocb(scsi_qla_host_t *, int, fc_port_t *, bool);
 extern void qla2x00_els_dcmd2_free(scsi_qla_host_t *vha,
 				   struct els_plogi *els_plogi);
 
-extern void qla2x00_update_fcports(scsi_qla_host_t *);
-
 extern int qla2x00_abort_isp(scsi_qla_host_t *);
 extern void qla2x00_abort_isp_cleanup(scsi_qla_host_t *);
 extern void qla2x00_quiesce_io(scsi_qla_host_t *);
@@ -206,8 +204,6 @@ extern int qla2x00_post_async_logout_work(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern int qla2x00_post_async_adisc_work(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
-extern int qla2x00_post_async_adisc_done_work(struct scsi_qla_host *,
-    fc_port_t *, uint16_t *);
 extern int qla2x00_set_exlogins_buffer(struct scsi_qla_host *);
 extern void qla2x00_free_exlogin_buffer(struct qla_hw_data *);
 extern int qla2x00_set_exchoffld_buffer(struct scsi_qla_host *);
@@ -217,7 +213,6 @@ extern int qla81xx_restart_mpi_firmware(scsi_qla_host_t *);
 
 extern struct scsi_qla_host *qla2x00_create_host(const struct scsi_host_template *,
 	struct qla_hw_data *);
-extern void qla2x00_free_host(struct scsi_qla_host *);
 extern void qla2x00_relogin(struct scsi_qla_host *);
 extern void qla2x00_do_work(struct scsi_qla_host *);
 extern void qla2x00_free_fcports(struct scsi_qla_host *);
@@ -239,13 +234,10 @@ extern int __qla83xx_clear_drv_presence(scsi_qla_host_t *vha);
 
 extern int qla2x00_post_uevent_work(struct scsi_qla_host *, u32);
 extern void qla2x00_disable_board_on_pci_error(struct work_struct *);
-extern void qla_eeh_work(struct work_struct *);
 extern void qla2x00_sp_compl(srb_t *sp, int);
 extern void qla2xxx_qpair_sp_free_dma(srb_t *sp);
 extern void qla2xxx_qpair_sp_compl(srb_t *sp, int);
 extern void qla24xx_sched_upd_fcport(fc_port_t *);
-void qla2x00_handle_login_done_event(struct scsi_qla_host *, fc_port_t *,
-	uint16_t *);
 int qla24xx_post_gnl_work(struct scsi_qla_host *, fc_port_t *);
 int qla24xx_post_relogin_work(struct scsi_qla_host *vha);
 void qla2x00_wait_for_sess_deletion(scsi_qla_host_t *);
@@ -729,7 +721,6 @@ int qla24xx_post_gpsc_work(struct scsi_qla_host *, fc_port_t *);
 int qla24xx_async_gpsc(scsi_qla_host_t *, fc_port_t *);
 void qla24xx_handle_gpsc_event(scsi_qla_host_t *, struct event_arg *);
 int qla2x00_mgmt_svr_login(scsi_qla_host_t *);
-void qla24xx_handle_gffid_event(scsi_qla_host_t *vha, struct event_arg *ea);
 int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport, bool);
 int qla24xx_async_gpnft(scsi_qla_host_t *, u8, srb_t *);
 void qla24xx_async_gpnft_done(scsi_qla_host_t *, srb_t *);
@@ -852,7 +843,6 @@ extern void qla2x00_start_iocbs(struct scsi_qla_host *, struct req_que *);
 
 /* Interrupt related */
 extern irqreturn_t qla82xx_intr_handler(int, void *);
-extern irqreturn_t qla82xx_msi_handler(int, void *);
 extern irqreturn_t qla82xx_msix_default(int, void *);
 extern irqreturn_t qla82xx_msix_rsp_q(int, void *);
 extern void qla82xx_enable_intrs(struct qla_hw_data *);
-- 
2.34.1

