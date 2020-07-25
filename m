Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 260B0C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 01:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04C622070B
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 01:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgGYBHl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 21:07:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:56027 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbgGYBHl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Jul 2020 21:07:41 -0400
IronPort-SDR: 0RuhHarvhRq/lhzfIWMC57ag0gjYLUwu+pLdkrF2WapXR6eJPl4ILTaDOq4CU+mb8bxxRGGvhe
 LreK8BuYtx1w==
X-IronPort-AV: E=McAfee;i="6000,8403,9692"; a="148710764"
X-IronPort-AV: E=Sophos;i="5.75,392,1589266800"; 
   d="scan'208";a="148710764"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2020 18:07:40 -0700
IronPort-SDR: RTMVBkwE67+RVtcBG2WdGoC8MsYYoHoDsmV8A3T3ZD8gDp/Vu8+g1QiypZjE9PndVTWCujQxEw
 f6CCqhLL+Ljg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,392,1589266800"; 
   d="scan'208";a="285098476"
Received: from lkp-server01.sh.intel.com (HELO df0563f96c37) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 24 Jul 2020 18:07:38 -0700
Received: from kbuild by df0563f96c37 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jz8f3-0000fe-S0; Sat, 25 Jul 2020 01:07:37 +0000
Date:   Sat, 25 Jul 2020 09:07:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tony Asleson <tasleson@redhat.com>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        b.zolnierkie@samsung.com, axboe@kernel.dk
Cc:     kbuild-all@lists.01.org
Subject: [RFC PATCH] libata: ata_scsi_durable_name() can be static
Message-ID: <20200725010702.GA6833@e0d222d6d31e>
References: <20200724171706.1550403-7-tasleson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724171706.1550403-7-tasleson@redhat.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Signed-off-by: kernel test robot <lkp@intel.com>
---
 libata-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ec1f6e406ceb2..32bd2426ca4f5 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1091,7 +1091,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
 	return 0;
 }
 
-int ata_scsi_durable_name(const struct device *dev, char *buf, size_t len)
+static int ata_scsi_durable_name(const struct device *dev, char *buf, size_t len)
 {
 	struct ata_device *ata_dev = container_of(dev, struct ata_device, tdev);
 
