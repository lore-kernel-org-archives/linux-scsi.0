Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFF9C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376710AbhLCXXj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:23:39 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:44847 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376419AbhLCXXj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:23:39 -0500
Received: by mail-pg1-f178.google.com with SMTP id m15so4495330pgu.11
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:20:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s7O4xhTSYP8Q0bPg49nT0d3KMYnj5r7if8HK6Jcwzk0=;
        b=GyVfws0PIFFgUeagflUET83XuM/+sMgKXpN6/Dm1MoOy2WmsUkEoongPZse/O7eG9E
         b1vOyz/czsOhm7XqDc668LYw1ivtmd+6kHSy2/iKwFFn0Reg4sZWNGKfA/j/+DgveF4m
         9pYBjQ1bPONoZe7ckb6jMrFWdw+ZYKS15kEsdsrS2m8G2Gvl3JZTULaWPDt43gSYqwfm
         WX+cJoe+Wg9eiPku/NBEbRlBYJetsyRypnszT1eEIqURr7WykMKSIbYIhuEt6xJSfvrC
         Zhd9Ueif5UOriKfmVTeoDF+l+xQBJw7Q7Y8tWMvl4Pd75mgnkKZ9ioyqJGTau0KLFgBG
         YxxA==
X-Gm-Message-State: AOAM5328jaHyhPd3PTftwiCmldQXSpv8lbbEnXnKoA3BqKhHGfrRxw8/
        kHW1ZFB9YF0e1bGnhwM8R2o=
X-Google-Smtp-Source: ABdhPJzU31XJaiDx1DLcs3T2j20uScHa1rc2cLnkr2aUgH/vwlq0zHx9MiBktqirkHn6+Np64dAOSg==
X-Received: by 2002:a63:2049:: with SMTP id r9mr6591875pgm.413.1638573614668;
        Fri, 03 Dec 2021 15:20:14 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:20:14 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
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
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v4 02/17] scsi: ufs: Rename a function argument
Date:   Fri,  3 Dec 2021 15:19:35 -0800
Message-Id: <20211203231950.193369-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
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
Tested-by: Bean Huo <beanhuo@micron.com>
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
