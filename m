Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E91CC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 10:40:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FC1320706
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 10:40:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404026AbgFYKk7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 06:40:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:36719 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404006AbgFYKk6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Jun 2020 06:40:58 -0400
IronPort-SDR: KlYDDIoXHtI11jk8DGn5HkkhMlfuSIagJ94UaYtNsVBrYJkxrfjwGvRIHMZnaAqJrr364OV4ne
 4+bq6qzmxUQQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="143930178"
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="143930178"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 03:40:58 -0700
IronPort-SDR: /26QjtPc2nQ6MVPSzR3ENM17k6QbC/fq3QXEX/3qjsOpE/EvdJOQgPn8Wl/k5tg3ezE0EwzNR7
 WrsDwlhTDPKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="423687171"
Received: from lkp-server01.sh.intel.com (HELO 538b5e3c8319) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 25 Jun 2020 03:40:55 -0700
Received: from kbuild by 538b5e3c8319 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1joPJO-0001YY-V0; Thu, 25 Jun 2020 10:40:54 +0000
Date:   Thu, 25 Jun 2020 18:40:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Deepak Ukey <deepak.ukey@microchip.com>, linux-scsi@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas.G@microchip.com, deepak.ukey@microchip.com,
        jinpu.wang@profitbricks.com, martin.petersen@oracle.com,
        dpf@google.com, yuuzheng@google.com, auradkar@google.com,
        vishakhavc@google.com
Subject: [RFC PATCH] pm80xx : pm8001_chip_get_phy_profile() can be static
Message-ID: <20200625104040.GA41093@9d911e2d61d0>
References: <20200624120322.6265-2-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624120322.6265-2-deepak.ukey@microchip.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Signed-off-by: kernel test robot <lkp@intel.com>
---
 pm80xx_hwi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index a909d00c6897a..9b60c42af83e1 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -5061,7 +5061,7 @@ pm80xx_chip_isr(struct pm8001_hba_info *pm8001_ha, u8 vec)
 	return IRQ_HANDLED;
 }
 
-int pm8001_chip_get_phy_profile(struct pm8001_hba_info *pm8001_ha, int phy_id,
+static int pm8001_chip_get_phy_profile(struct pm8001_hba_info *pm8001_ha, int phy_id,
 		int page_code, struct completion *comp, void *buf)
 {
 	u32 tag;
