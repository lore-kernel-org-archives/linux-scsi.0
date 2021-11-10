Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62242C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ECE061184
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhKJArs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 19:47:48 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:39788 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbhKJArr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 19:47:47 -0500
Received: by mail-pg1-f178.google.com with SMTP id g184so634297pgc.6
        for <linux-scsi@vger.kernel.org>; Tue, 09 Nov 2021 16:45:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mRkJNMhTrXc4dm3oK22XOgQhWgx38cXwyseM6/UIDOc=;
        b=eW7toWgsssrYK3cpRXcTaQmuzAIl7z34bAgcroyMjfiY/HlR1ej3JynH/W0l3MJNyU
         rbnuPL112x1r306Nusy6Q9Uk/oxVJpKbQWEyzEeBnDznSkkUWOlPV4xiPSLqFc4FIuxq
         NjfGRMtHJXqz73ptTijmtNSa65vNgwdfuekfso26qdmuOh3ry73LpTH9jaGuJyU3kqhA
         J9lWV5kUUVyrs/l2f4NPTNYyw/ejv7cggU3bWWL0AAYI3pR5NZUKowxW/vgniCXFyzIf
         whnCViLVvOTFfV0JgLExgqoP2u6v8Qrtc1nuUGXult+T64KNHHpItIkVChZILVS8QkUJ
         7Z+w==
X-Gm-Message-State: AOAM530lKchYl2gTlrYu71dsdnssDbLKjU6qBNN+bW09X9fypTsSEsnz
        QVtgH8fAU+I6OZLxzq8V1vU=
X-Google-Smtp-Source: ABdhPJxsnKQLxpx/QOPHLGtTgQDkpG34IqI8h5htbXGzC0nwkY8Go3B0GJu/Hp0Tdu5o2Nr5cw97DA==
X-Received: by 2002:a05:6a00:1817:b0:49f:b893:6be0 with SMTP id y23-20020a056a00181700b0049fb8936be0mr12666795pfa.48.1636505100718;
        Tue, 09 Nov 2021 16:45:00 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a582:6939:6a97:9cbf])
        by smtp.gmail.com with ESMTPSA id l17sm21868826pfc.94.2021.11.09.16.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 16:45:00 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Yue Hu <huyue2@yulong.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH 01/11] scsi: ufs: Rename a function argument
Date:   Tue,  9 Nov 2021 16:44:30 -0800
Message-Id: <20211110004440.3389311-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
In-Reply-To: <20211110004440.3389311-1-bvanassche@acm.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The new name makes it clear what the meaning of the function argument is.

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
index 4ceb3c7e65b4..a911ad72de7a 100644
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
