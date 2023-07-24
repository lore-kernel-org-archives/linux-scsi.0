Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9C5EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 20:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjGXU0z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 16:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjGXU0u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 16:26:50 -0400
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9992DA4
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:26:49 -0700 (PDT)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6862842a028so2649646b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:26:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690230409; x=1690835209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=563VffW3Uy+r3abjWrZuyixxWzr0gBZBrWYktfPazIo=;
        b=hiwBltRbiIOte4HFizAw/rG/L7JYypxDap6UG596LqSyxoM6f1fH+Z6zrlgQGBSVOP
         BNn9XGMOUWAvCsYTtSVJYJhKAFxFvSyU4nNwG40/W1axuW2tcCgr7J4MKokyicJqMeMq
         WlwdvmcHfW8JgGZB97yjo12c2VMSHDuiE8YQR7TQj4L+hsWseBL+BdMnHJoP+aOk5ADc
         IN2bxisGZ6x4nF/lJK2UJC3dVvp+sXUu+3j0r5L2yYvMEbzSOEIBoFmscHoaKQD8uL+/
         5BbcKdQl0UFScypXQuc7tJJzZp1yv9s/E8HH/4zT+/B43ltGsZO97/Veba/WDNEid7jY
         eAMA==
X-Gm-Message-State: ABy/qLaH230Afws09r1noRRA8ofYf94FokFr2d5zGiBp+Xvbmjl5bkTu
        qxGOOS4uS4eKWMX8OhnGLvs=
X-Google-Smtp-Source: APBJJlGCeatyz3qMHhPKen5QVq3pY/EGMsb48YrvPyhEpHsCVng6oEDBmp/p6pgm+iLISZzz1FeTUQ==
X-Received: by 2002:a05:6a00:8d6:b0:686:49b0:21ca with SMTP id s22-20020a056a0008d600b0068649b021camr10134536pfu.7.1690230408916;
        Mon, 24 Jul 2023 13:26:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bda6:6519:2a73:345e])
        by smtp.gmail.com with ESMTPSA id v13-20020aa7850d000000b00653fe2d527esm8185540pfn.32.2023.07.24.13.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 13:26:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 03/12] scsi: ufs: Fix kernel-doc headers
Date:   Mon, 24 Jul 2023 13:16:38 -0700
Message-ID: <20230724202024.3379114-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230724202024.3379114-1-bvanassche@acm.org>
References: <20230724202024.3379114-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the remaining kernel-doc warnings that are reported when building with
W=2.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/host/cdns-pltfrm.c | 13 ++++---------
 drivers/ufs/host/tc-dwc-g210.c | 20 ++++++--------------
 drivers/ufs/host/ufshcd-dwc.c  | 16 ++++++----------
 3 files changed, 16 insertions(+), 33 deletions(-)

diff --git a/drivers/ufs/host/cdns-pltfrm.c b/drivers/ufs/host/cdns-pltfrm.c
index 9c96aa8810ac..2491e7e87028 100644
--- a/drivers/ufs/host/cdns-pltfrm.c
+++ b/drivers/ufs/host/cdns-pltfrm.c
@@ -101,8 +101,7 @@ static void cdns_ufs_set_l4_attr(struct ufs_hba *hba)
 }
 
 /**
- * cdns_ufs_set_hclkdiv()
- * Sets HCLKDIV register value based on the core_clk
+ * cdns_ufs_set_hclkdiv() - set HCLKDIV register value based on the core_clk.
  * @hba: host controller instance
  *
  * Return: zero for success and non-zero for failure.
@@ -143,8 +142,7 @@ static int cdns_ufs_set_hclkdiv(struct ufs_hba *hba)
 }
 
 /**
- * cdns_ufs_hce_enable_notify()
- * Called before and after HCE enable bit is set.
+ * cdns_ufs_hce_enable_notify() - set HCLKDIV register
  * @hba: host controller instance
  * @status: notify stage (pre, post change)
  *
@@ -160,12 +158,10 @@ static int cdns_ufs_hce_enable_notify(struct ufs_hba *hba,
 }
 
 /**
- * cdns_ufs_hibern8_notify()
- * Called around hibern8 enter/exit.
+ * cdns_ufs_hibern8_notify() - save and restore L4 attributes.
  * @hba: host controller instance
  * @cmd: UIC Command
  * @status: notify stage (pre, post change)
- *
  */
 static void cdns_ufs_hibern8_notify(struct ufs_hba *hba, enum uic_cmd_dme cmd,
 				    enum ufs_notify_change_status status)
@@ -177,8 +173,7 @@ static void cdns_ufs_hibern8_notify(struct ufs_hba *hba, enum uic_cmd_dme cmd,
 }
 
 /**
- * cdns_ufs_link_startup_notify()
- * Called before and after Link startup is carried out.
+ * cdns_ufs_link_startup_notify() - handle link startup.
  * @hba: host controller instance
  * @status: notify stage (pre, post change)
  *
diff --git a/drivers/ufs/host/tc-dwc-g210.c b/drivers/ufs/host/tc-dwc-g210.c
index 84a8b915b745..0ac53cc8465e 100644
--- a/drivers/ufs/host/tc-dwc-g210.c
+++ b/drivers/ufs/host/tc-dwc-g210.c
@@ -17,8 +17,7 @@
 #include "tc-dwc-g210.h"
 
 /**
- * tc_dwc_g210_setup_40bit_rmmi()
- * This function configures Synopsys TC specific atributes (40-bit RMMI)
+ * tc_dwc_g210_setup_40bit_rmmi() - configure 40-bit RMMI.
  * @hba: Pointer to drivers structure
  *
  * Return: 0 on success or non-zero value on failure.
@@ -81,8 +80,7 @@ static int tc_dwc_g210_setup_40bit_rmmi(struct ufs_hba *hba)
 }
 
 /**
- * tc_dwc_g210_setup_20bit_rmmi_lane0()
- * This function configures Synopsys TC 20-bit RMMI Lane 0
+ * tc_dwc_g210_setup_20bit_rmmi_lane0() - configure 20-bit RMMI Lane 0.
  * @hba: Pointer to drivers structure
  *
  * Return: 0 on success or non-zero value on failure.
@@ -134,8 +132,7 @@ static int tc_dwc_g210_setup_20bit_rmmi_lane0(struct ufs_hba *hba)
 }
 
 /**
- * tc_dwc_g210_setup_20bit_rmmi_lane1()
- * This function configures Synopsys TC 20-bit RMMI Lane 1
+ * tc_dwc_g210_setup_20bit_rmmi_lane1() - configure 20-bit RMMI Lane 1.
  * @hba: Pointer to drivers structure
  *
  * Return: 0 on success or non-zero value on failure.
@@ -211,8 +208,7 @@ static int tc_dwc_g210_setup_20bit_rmmi_lane1(struct ufs_hba *hba)
 }
 
 /**
- * tc_dwc_g210_setup_20bit_rmmi()
- * This function configures Synopsys TC specific atributes (20-bit RMMI)
+ * tc_dwc_g210_setup_20bit_rmmi() - configure 20-bit RMMI.
  * @hba: Pointer to drivers structure
  *
  * Return: 0 on success or non-zero value on failure.
@@ -251,9 +247,7 @@ static int tc_dwc_g210_setup_20bit_rmmi(struct ufs_hba *hba)
 }
 
 /**
- * tc_dwc_g210_config_40_bit()
- * This function configures Local (host) Synopsys 40-bit TC specific attributes
- *
+ * tc_dwc_g210_config_40_bit() - configure 40-bit TC specific attributes.
  * @hba: Pointer to drivers structure
  *
  * Return: 0 on success non-zero value on failure.
@@ -283,9 +277,7 @@ int tc_dwc_g210_config_40_bit(struct ufs_hba *hba)
 EXPORT_SYMBOL(tc_dwc_g210_config_40_bit);
 
 /**
- * tc_dwc_g210_config_20_bit()
- * This function configures Local (host) Synopsys 20-bit TC specific attributes
- *
+ * tc_dwc_g210_config_20_bit() - configure 20-bit TC specific attributes.
  * @hba: Pointer to drivers structure
  *
  * Return: 0 on success non-zero value on failure.
diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index b547df05a2b9..21b1cf912dcc 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -34,9 +34,7 @@ int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 EXPORT_SYMBOL(ufshcd_dwc_dme_set_attrs);
 
 /**
- * ufshcd_dwc_program_clk_div()
- * This function programs the clk divider value. This value is needed to
- * provide 1 microsecond tick to unipro layer.
+ * ufshcd_dwc_program_clk_div() - program clock divider.
  * @hba: Private Structure pointer
  * @divider_val: clock divider value to be programmed
  *
@@ -47,8 +45,7 @@ static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
 }
 
 /**
- * ufshcd_dwc_link_is_up()
- * Check if link is up
+ * ufshcd_dwc_link_is_up() - check if link is up.
  * @hba: private structure pointer
  *
  * Return: 0 on success, non-zero value on failure.
@@ -68,7 +65,9 @@ static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_dwc_connection_setup()
+ * ufshcd_dwc_connection_setup() - configure unipro attributes.
+ * @hba: pointer to drivers private data
+ *
  * This function configures both the local side (host) and the peer side
  * (device) unipro attributes to establish the connection to application/
  * cport.
@@ -76,8 +75,6 @@ static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
  * have this connection setup on reset. But invoking this function does no
  * harm and should be fine even working with any ufs device.
  *
- * @hba: pointer to drivers private data
- *
  * Return: 0 on success non-zero value on failure.
  */
 static int ufshcd_dwc_connection_setup(struct ufs_hba *hba)
@@ -107,8 +104,7 @@ static int ufshcd_dwc_connection_setup(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_dwc_link_startup_notify()
- * UFS Host DWC specific link startup sequence
+ * ufshcd_dwc_link_startup_notify() - program clock divider.
  * @hba: private structure pointer
  * @status: Callback notify status
  *
