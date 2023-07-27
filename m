Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 529EBEB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 19:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjG0TqY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 15:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjG0TqX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 15:46:23 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7975F273C
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:46:22 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-686bc261111so1077912b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:46:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690487182; x=1691091982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1oT6hB/5SaAbcAvfnToKA+2yv5LSyr863W5xnvqiRPU=;
        b=BD3iEqWzg+Fn18RlcpsLeu761S4rvYhY68p9VtaIh/lPJGGfrkIFt9oC5jQXpjwOW8
         rR7Eu9Vq+FsC5T0hk1yNxpAl4MMpuihFkT+1x/dRLnh2u1xRZ+i5/PlU5Z3hQ9mGs9R+
         M+3ejj8f5sdrMDgKVO9nW2aNcQOQt7D+w53xOEOsS6RaYvjVvxEXH8tuy1JA2q+nfIOl
         r2KghR2zMKd3TQp2lRDfAtjD3EFqaY0zUwueYsmTSARNqZ9KZM/04oPDk7L6V4r3nNXM
         uLzArzuqSiA9lvxCpWoNOCaObWyWUjQrd1Qhp/rMLwFBVcSCnWU2m2TbuiagHsA8kk/k
         PArg==
X-Gm-Message-State: ABy/qLYRm2YzoptdgoGoYsZWgn9MkedbGIjpYtSt0oEcg57KeLQIacox
        b8mJzTd0oZ41Xgp4vklKtLU=
X-Google-Smtp-Source: APBJJlEtIYXeJWp/j6zJ2pfdiUsjedhAe2vj0XpLPWmJSAKVQ9+Wt6Y4urvv0Pzcdx0XLDM1NFOuZg==
X-Received: by 2002:a05:6a20:42a4:b0:12c:f581:c3a3 with SMTP id o36-20020a056a2042a400b0012cf581c3a3mr56963pzj.6.1690487181690;
        Thu, 27 Jul 2023 12:46:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:607:27ba:91cb:68ee])
        by smtp.gmail.com with ESMTPSA id 35-20020a630b23000000b00551df489590sm1879203pgl.12.2023.07.27.12.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 12:46:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH v2 02/12] scsi: ufs: Document all return values
Date:   Thu, 27 Jul 2023 12:41:14 -0700
Message-ID: <20230727194457.3152309-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230727194457.3152309-1-bvanassche@acm.org>
References: <20230727194457.3152309-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes multiple W=2 kernel-doc warnings.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs_bsg.c       |  2 ++
 drivers/ufs/core/ufshcd.c        | 38 ++++++++++++++++++++++++++++++++
 drivers/ufs/host/cdns-pltfrm.c   |  4 ++--
 drivers/ufs/host/ufshcd-pltfrm.c |  2 ++
 4 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 0d38e7fa34cc..34e423924e06 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -232,6 +232,8 @@ static inline void ufs_bsg_node_release(struct device *dev)
  * @hba: per adapter object
  *
  * Called during initial loading of the driver, and before scsi_scan_host.
+ *
+ * Returns: 0 (success).
  */
 int ufs_bsg_probe(struct ufs_hba *hba)
 {
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d7b83230ddbb..ca520f2b1820 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -876,6 +876,8 @@ static inline u32 ufshcd_get_dme_attr_val(struct ufs_hba *hba)
 /**
  * ufshcd_get_req_rsp - returns the TR response transaction type
  * @ucd_rsp_ptr: pointer to response UPIU
+ *
+ * Return: UPIU type.
  */
 static inline int
 ufshcd_get_req_rsp(struct utp_upiu_rsp *ucd_rsp_ptr)
@@ -2241,6 +2243,8 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
  * descriptor
  * @hba: per adapter instance
  * @lrbp: pointer to local reference block
+ *
+ * Return: 0 upon success; < 0 upon failure.
  */
 static
 int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
@@ -2713,6 +2717,8 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
  *			     for Device Management Purposes
  * @hba: per adapter instance
  * @lrbp: pointer to local reference block
+ *
+ * Return: 0 upon success; < 0 upon failure.
  */
 static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
 				      struct ufshcd_lrb *lrbp)
@@ -2741,6 +2747,8 @@ static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
  *			   for SCSI Purposes
  * @hba: per adapter instance
  * @lrbp: pointer to local reference block
+ *
+ * Return: 0 upon success; < 0 upon failure.
  */
 static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
@@ -3018,6 +3026,8 @@ ufshcd_check_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
  * ufshcd_dev_cmd_completion() - handles device management command responses
  * @hba: per adapter instance
  * @lrbp: pointer to local reference block
+ *
+ * Return: 0 upon success; < 0 upon failure.
  */
 static int
 ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
@@ -3155,6 +3165,8 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
  * @cmd_type: specifies the type (NOP, Query...)
  * @timeout: timeout in milliseconds
  *
+ * Return: 0 upon success; < 0 upon failure.
+ *
  * NOTE: Since there is only one available tag for device management commands,
  * it is expected you hold the hba->dev_cmd.lock mutex.
  */
@@ -4387,6 +4399,8 @@ static void ufshcd_init_pwr_info(struct ufs_hba *hba)
 /**
  * ufshcd_get_max_pwr_mode - reads the max power mode negotiated with device
  * @hba: per-adapter instance
+ *
+ * Return: 0 upon success; < 0 upon failure.
  */
 static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 {
@@ -4544,6 +4558,8 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
  * ufshcd_config_pwr_mode - configure a new power mode
  * @hba: per-adapter instance
  * @desired_pwr_mode: desired power configuration
+ *
+ * Return: 0 upon success; < 0 upon failure.
  */
 int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 		struct ufs_pa_layer_attr *desired_pwr_mode)
@@ -4568,6 +4584,8 @@ EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
  * @hba: per-adapter instance
  *
  * Set fDeviceInit flag and poll until device toggles it.
+ *
+ * Return: 0 upon success; < 0 upon failure.
  */
 static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 {
@@ -4939,6 +4957,8 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
  * If the UTP layer at the device side is not initialized, it may
  * not respond with NOP IN UPIU within timeout of %NOP_OUT_TIMEOUT
  * and we retry sending NOP OUT for %NOP_OUT_RETRIES iterations.
+ *
+ * Return: 0 upon success; < 0 upon failure.
  */
 static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 {
@@ -5099,6 +5119,8 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
  * @depth: required depth to set
  *
  * Change queue depth and make sure the max. limits are not crossed.
+ *
+ * Return: new queue depth.
  */
 static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth)
 {
@@ -5108,6 +5130,8 @@ static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth)
 /**
  * ufshcd_slave_configure - adjust SCSI device configurations
  * @sdev: pointer to SCSI device
+ *
+ * Return: 0 (success).
  */
 static int ufshcd_slave_configure(struct scsi_device *sdev)
 {
@@ -5824,6 +5848,8 @@ static int ufshcd_bkops_ctrl(struct ufs_hba *hba,
  *
  * If BKOPs is enabled, this function returns 0, 1 if the bkops in not enabled
  * and negative error value for any other failure.
+ *
+ * Return: 0 upon success; < 0 upon failure.
  */
 static int ufshcd_urgent_bkops(struct ufs_hba *hba)
 {
@@ -7064,6 +7090,8 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
  *
  * Since there is only one available tag for device management commands,
  * the caller is expected to hold the hba->dev_cmd.lock mutex.
+ *
+ * Return: 0 upon success; < 0 upon failure.
  */
 static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 					struct utp_upiu_req *req_upiu,
@@ -7165,6 +7193,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
  * Management requests.
  * It is up to the caller to fill the upiu conent properly, as it will
  * be copied without any further input validations.
+ *
+ * Return: 0 upon success; < 0 upon failure.
  */
 int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     struct utp_upiu_req *req_upiu,
@@ -8478,6 +8508,8 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
 /**
  * ufshcd_add_lus - probe and add UFS logical units
  * @hba: per-adapter instance
+ *
+ * Return: 0 upon success; < 0 upon failure.
  */
 static int ufshcd_add_lus(struct ufs_hba *hba)
 {
@@ -8687,6 +8719,8 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
  * @init_dev_params: whether or not to call ufshcd_device_params_init().
  *
  * Execute link-startup and verify device initialization
+ *
+ * Return: 0 upon success; < 0 upon failure.
  */
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 {
@@ -9841,6 +9875,8 @@ static int ufshcd_wl_resume(struct device *dev)
  *
  * This function will put disable irqs, turn off clocks
  * and set vreg and hba-vreg in lpm mode.
+ *
+ * Return: 0 upon success; < 0 upon failure.
  */
 static int ufshcd_suspend(struct ufs_hba *hba)
 {
@@ -10002,6 +10038,8 @@ EXPORT_SYMBOL(ufshcd_runtime_suspend);
  *
  * 1. Turn on all the controller related clocks
  * 2. Turn ON VCC rail
+ *
+ * Return: 0 upon success; < 0 upon failure.
  */
 int ufshcd_runtime_resume(struct device *dev)
 {
diff --git a/drivers/ufs/host/cdns-pltfrm.c b/drivers/ufs/host/cdns-pltfrm.c
index 5b1e1e26d133..9c96aa8810ac 100644
--- a/drivers/ufs/host/cdns-pltfrm.c
+++ b/drivers/ufs/host/cdns-pltfrm.c
@@ -235,7 +235,7 @@ static int cdns_ufs_init(struct ufs_hba *hba)
  * cdns_ufs_m31_16nm_phy_initialization - performs m31 phy initialization
  * @hba: host controller instance
  *
- * Always returns 0
+ * Return: 0 (success).
  */
 static int cdns_ufs_m31_16nm_phy_initialization(struct ufs_hba *hba)
 {
@@ -308,7 +308,7 @@ static int cdns_ufs_pltfrm_probe(struct platform_device *pdev)
  * cdns_ufs_pltfrm_remove - removes the ufs driver
  * @pdev: pointer to platform device handle
  *
- * Always returns 0
+ * Return: 0 (success).
  */
 static int cdns_ufs_pltfrm_remove(struct platform_device *pdev)
 {
diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index 34131d36d09f..8729f45d4f83 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -166,6 +166,8 @@ EXPORT_SYMBOL_GPL(ufshcd_populate_vreg);
  * If any of the supplies are not defined it is assumed that they are always-on
  * and hence return zero. If the property is defined but parsing is failed
  * then return corresponding error.
+ *
+ * Return: 0 upon success; < 0 upon failure.
  */
 static int ufshcd_parse_regulator_info(struct ufs_hba *hba)
 {
