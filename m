Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEF4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241159AbhK3XhI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:37:08 -0500
Received: from mail-pl1-f171.google.com ([209.85.214.171]:36849 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241095AbhK3XhB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:37:01 -0500
Received: by mail-pl1-f171.google.com with SMTP id u11so16210012plf.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:33:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rrrrLIqTiCPIc2x/fw9rWnKpd2BAH4hDd4xjJM9vM+0=;
        b=rQxQGGPGyEKwOUDPdgaG0aBK260sBWsr9NFCAvDQ5pZDZkbaG8yqjYIdTOJ487Ac03
         4RHDoTDg3DmNPQgX97+e/qcKD+nPB4IpTg0asCMdATHBrbAjDZ8rlsxcBNpukZVQ01Va
         EB4WANWTcyjm9VBbo4GKA5UWoHIxp5ylGruxRBdMqc8GcMnqK3XS8NzQxN+audZtlc+m
         VMtWSvcaXERSo0n+NVV9OJTCYCEv1f3dUbRdJlkAgQCj49NiVR68CayAY4OFQUVhzwwV
         iJu66DgtQsl2LJGRmfeGLDo2TbNCMiDDR2mIZUI8h67suJlN4224/J/GdEWvfJ3yvKe/
         7PFQ==
X-Gm-Message-State: AOAM531aCSxMVlW+pXA6mEnGxWdVL3HiQ8ytca5y8naNemUy0LxiTJpl
        RIX43q8hvuvOfyStW+iMIbw=
X-Google-Smtp-Source: ABdhPJxnodbDOlUjs8r3gJtIFVGJZV2PAP+mKAJrCJVEMEF0RcJUAyQXAWZXT3OVi606PA5QbILUbw==
X-Received: by 2002:a17:90b:2245:: with SMTP id hk5mr2821936pjb.6.1638315221576;
        Tue, 30 Nov 2021 15:33:41 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:33:41 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Yue Hu <huyue2@yulong.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v3 03/17] scsi: ufs: Rename a function argument
Date:   Tue, 30 Nov 2021 15:33:10 -0800
Message-Id: <20211130233324.1402448-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The new name makes it clear what the meaning of the function argument is.

Reviewed-by: Chanho Park <chanho61.park@samsung.com>
Acked-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Keoseong Park <keosung.park@samsung.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
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
index 6103e98e9a08..28c1bbe9fa7d 100644
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
