Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55860C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41C3E61B39
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbhKSUBJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:01:09 -0500
Received: from mail-pj1-f46.google.com ([209.85.216.46]:53842 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbhKSUBF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:01:05 -0500
Received: by mail-pj1-f46.google.com with SMTP id iq11so8688544pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:58:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gi+JJLYbHJTEfkSpuhO4oQ8dGAZk13VBQ+8Kc7blEkY=;
        b=sXaOMli5/cD+7qZW8feIXJsvlLlp9QpwGpmKr3ZFyCiLFMIsjFB1CURGEZ5YmuYv82
         youp/GYsyg4H6SBZO/ly1+9W2cYzKDSXuTJZx9RWwkk3+RqgNKMDKloEYdRKradYtxx5
         Wrr6dfauFwUeOy7kv+/4HSBthOSRSfIcMhj0mbMGZCJ/RZQ2XHIsjpmnbI1RItTHotSj
         R3RwSZJXnDFuileS71QZPbwuxmBJA+ktGqWT4cL0fvl4yn4sNEk0kv3jEsMdwYDxxQ5V
         BSQSK15kpgD2odRLCwmWlKCLRW34ODws30U3/pzFtMdaW7n7Uzk0FvzIFZOsaJjahLMc
         IEGQ==
X-Gm-Message-State: AOAM533r9IQQtA9/GhMJJVgfKnoMd31g4Yubs2s2i9904fgIKCH6vWwm
        rRanbTqXD1XGL3eH5f0rNNY=
X-Google-Smtp-Source: ABdhPJxOyeRceqtSDPJQOqHQiwMCcY21XfUL+ccR3SsVpdrjd8zzor3ukyUVcvm2XgQ6nTQ6OI402w==
X-Received: by 2002:a17:90a:9dca:: with SMTP id x10mr2815617pjv.170.1637351883529;
        Fri, 19 Nov 2021 11:58:03 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:58:02 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Yue Hu <huyue2@yulong.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 07/20] scsi: ufs: Rename a function argument
Date:   Fri, 19 Nov 2021 11:57:30 -0800
Message-Id: <20211119195743.2817-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The new name makes it clear what the meaning of the function argument is.

Reviewed-by: Chanho Park <chanho61.park@samsung.com>
Acked-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Keoseong Park <keosung.park@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-exynos.c | 4 ++--
 drivers/scsi/ufs/ufshcd.h     | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index cd26bc82462e..474a4a064a68 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -853,14 +853,14 @@ static int exynos_ufs_post_pwr_mode(struct ufs_hba *hba,
 }
 
 static void exynos_ufs_specify_nexus_t_xfer_req(struct ufs_hba *hba,
-						int tag, bool op)
+						int tag, bool is_scsi_cmd)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 	u32 type;
 
 	type =  hci_readl(ufs, HCI_UTRL_NEXUS_TYPE);
 
-	if (op)
+	if (is_scsi_cmd)
 		hci_writel(ufs, type | (1 << tag), HCI_UTRL_NEXUS_TYPE);
 	else
 		hci_writel(ufs, type & ~(1 << tag), HCI_UTRL_NEXUS_TYPE);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 54750d72c8fb..ebe9e197d804 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -338,7 +338,8 @@ struct ufs_hba_variant_ops {
 					enum ufs_notify_change_status status,
 					struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
-	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
+	void	(*setup_xfer_req)(struct ufs_hba *hba, int tag,
+				  bool is_scsi_cmd);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
 	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
 					enum ufs_notify_change_status);
