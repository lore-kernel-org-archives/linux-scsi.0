Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF480C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 12:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE4E6204EC
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 12:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404355AbgFYMAi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 08:00:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:2494 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404285AbgFYMAi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Jun 2020 08:00:38 -0400
IronPort-SDR: aWyLI+QWhxZQmUh0WbLcVC45CA8YRpYR03uqWXML6m409mO1wWeZ/xWG1oZUjDiaIgH/kj+RTw
 yzHAsbQKR/0g==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="229574160"
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="229574160"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 05:00:37 -0700
IronPort-SDR: RRdd11iqzbMlhPLlbSKEAzlZoQ7FPNxJD/fE2iNg+eO0Vr/psKaGGae25jg/Kuc8pwssbLo9go
 R+k3XrugJioA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="301965447"
Received: from lkp-server01.sh.intel.com (HELO 538b5e3c8319) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jun 2020 05:00:35 -0700
Received: from kbuild by 538b5e3c8319 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1joQYU-0001ay-LX; Thu, 25 Jun 2020 12:00:34 +0000
Date:   Thu, 25 Jun 2020 19:59:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Deepak Ukey <deepak.ukey@microchip.com>, linux-scsi@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas.G@microchip.com, deepak.ukey@microchip.com,
        jinpu.wang@profitbricks.com, martin.petersen@oracle.com,
        dpf@google.com, yuuzheng@google.com, auradkar@google.com,
        vishakhavc@google.com
Subject: [RFC PATCH] pm80xx : pm8001_queue_phyup() can be static
Message-ID: <20200625115948.GA63645@9d911e2d61d0>
References: <20200624120322.6265-3-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624120322.6265-3-deepak.ukey@microchip.com>
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
index 748c7a06262fb..80e992d9ea314 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -49,7 +49,7 @@
 static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 	u32 phyId, u32 phy_op);
 
-void  pm8001_queue_phyup(struct pm8001_hba_info *pm8001_ha, int phy_id)
+static void  pm8001_queue_phyup(struct pm8001_hba_info *pm8001_ha, int phy_id)
 {
 	int i;
 
