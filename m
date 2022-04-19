Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE46C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358397AbiDSXBp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358393AbiDSXBl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:41 -0400
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A47387A7
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:57 -0700 (PDT)
Received: by mail-pf1-f177.google.com with SMTP id a15so168548pfv.11
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AR/WNtu1VUoxOK89WguYB/NAu+Nz/Pd74zMlFYIM9TM=;
        b=A8Y08WC0xPPYA8gzpv0SMI+VM7pOctSVskNZrQrT6vkikm9bCAAT4DRmXuJ70n4etH
         gClEiMllTl5CXAKEwiTzqXzb2LFdfjQX2t6ZdE9aHywbwy95PQPeKTFEtHlaCY6eaPG7
         ldcd5CLKMBhRN0ZoTjAeYh151zUuHVGgPjS+LxyeDfwpavGlQxjc3X2Vj17zq6UQZQLq
         LZoT0wGahHJdM6kXYQmWhrelUzf1uArmatZD3lni5jOsU9gNwU1X3yodMyultwXH847Z
         eWvuHDFw6onulEz34wpnZGp/2ebVKxn7RjGACjVgiEZuLGMMGP0RNhZp9A37ZFFkCQq3
         WXeg==
X-Gm-Message-State: AOAM531U2QJ9ttB5qTttazM9rTNZsMq3Ep4qNVHQxbduWBz31PJejhBZ
        7mxvyF86CQgcjkMJmGhsXMM=
X-Google-Smtp-Source: ABdhPJx0eUGW9QViQHrSPGLoV/qoswaLn0070LOc7B96RVAjtyH8s5XFeF7kPfTKf75JpqGb6mdJDg==
X-Received: by 2002:a65:56cb:0:b0:378:82ed:d74 with SMTP id w11-20020a6556cb000000b0037882ed0d74mr16724061pgs.491.1650409136811;
        Tue, 19 Apr 2022 15:58:56 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 19/28] scsi: ufs: Remove the TRUE and FALSE definitions
Date:   Tue, 19 Apr 2022 15:58:02 -0700
Message-Id: <20220419225811.4127248-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the Linux kernel coding style document
(Documentation/process/coding-style.rst) it is recommended to use the type
'bool' and also the values 'true' and 'false'. Hence this patch that
removes the definitions and uses of TRUE and FALSE from the UFS driver.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-exynos.c |  4 ++--
 drivers/scsi/ufs/ufs-exynos.h |  8 ++++----
 drivers/scsi/ufs/ufshcd.c     |  8 ++++----
 drivers/scsi/ufs/unipro.h     | 14 --------------
 4 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 474a4a064a68..0b99c74955ef 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -704,7 +704,7 @@ static void exynos_ufs_establish_connt(struct exynos_ufs *ufs)
 
 	/* local unipro attributes */
 	ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID), DEV_ID);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), TRUE);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), true);
 	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERDEVICEID), PEER_DEV_ID);
 	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERCPORTID), PEER_CPORT_ID);
 	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTFLAGS), CPORT_DEF_FLAGS);
@@ -1028,7 +1028,7 @@ static int exynos_ufs_post_link(struct ufs_hba *hba)
 
 	if (ufs->opts & EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB)
 		ufshcd_dme_set(hba,
-			UIC_ARG_MIB(T_DBG_SKIP_INIT_HIBERN8_EXIT), TRUE);
+			UIC_ARG_MIB(T_DBG_SKIP_INIT_HIBERN8_EXIT), true);
 
 	if (attr->pa_granularity) {
 		exynos_ufs_enable_dbg_mode(hba);
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 1c33e5466082..0b0a3d530ca6 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -248,22 +248,22 @@ long exynos_ufs_calc_time_cntr(struct exynos_ufs *, long);
 
 static inline void exynos_ufs_enable_ov_tm(struct ufs_hba *hba)
 {
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OV_TM), TRUE);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OV_TM), true);
 }
 
 static inline void exynos_ufs_disable_ov_tm(struct ufs_hba *hba)
 {
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OV_TM), FALSE);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OV_TM), false);
 }
 
 static inline void exynos_ufs_enable_dbg_mode(struct ufs_hba *hba)
 {
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), TRUE);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), true);
 }
 
 static inline void exynos_ufs_disable_dbg_mode(struct ufs_hba *hba)
 {
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), FALSE);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), false);
 }
 
 #endif /* _UFS_EXYNOS_H_ */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e0535e4d8669..37527865e26b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4325,18 +4325,18 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			pwr_mode->lane_rx);
 	if (pwr_mode->pwr_rx == FASTAUTO_MODE ||
 			pwr_mode->pwr_rx == FAST_MODE)
-		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), TRUE);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), true);
 	else
-		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), FALSE);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), false);
 
 	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXGEAR), pwr_mode->gear_tx);
 	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVETXDATALANES),
 			pwr_mode->lane_tx);
 	if (pwr_mode->pwr_tx == FASTAUTO_MODE ||
 			pwr_mode->pwr_tx == FAST_MODE)
-		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), TRUE);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), true);
 	else
-		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), FALSE);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), false);
 
 	if (pwr_mode->pwr_rx == FASTAUTO_MODE ||
 	    pwr_mode->pwr_tx == FASTAUTO_MODE ||
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 64647aa5c2e0..0521f887e3ac 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -298,20 +298,6 @@ enum ufs_unipro_ver {
 #define T_TC0TXMAXSDUSIZE	0x4060
 #define T_TC1TXMAXSDUSIZE	0x4061
 
-#ifdef FALSE
-#undef FALSE
-#endif
-
-#ifdef TRUE
-#undef TRUE
-#endif
-
-/* Boolean attribute values */
-enum {
-	FALSE = 0,
-	TRUE,
-};
-
 /* CPort setting */
 #define E2EFC_ON	(1 << 0)
 #define E2EFC_OFF	(0 << 0)
