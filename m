Return-Path: <SRS0=d7EE=5G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C88C4332D
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 16:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15CE120753
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 16:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbgCUQuq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Mar 2020 12:50:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:45121 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgCUQup (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 21 Mar 2020 12:50:45 -0400
IronPort-SDR: 1Ir5hf/6lfE31PxXiveI16rgsQnAMJGmv+Whkh5a9YCinKj5FDwQO/ueLgafIeMXrzmcdzleP4
 9nwPy2ZDUiWg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 09:50:45 -0700
IronPort-SDR: gGMm3tTt3ufh8UE9crFA7mOExzVBeQQQ4RoOjfKF0l3xcDkCaOTdSEFxxmTp0hM64JiRdt01E0
 1uQtTKW8vdhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,289,1580803200"; 
   d="scan'208";a="280746322"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 21 Mar 2020 09:50:41 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jFhKa-0003Ku-W2; Sun, 22 Mar 2020 00:50:40 +0800
Date:   Sun, 22 Mar 2020 00:50:21 +0800
From:   kbuild test robot <lkp@intel.com>
To:     huobean@gmail.com
Cc:     kbuild-all@lists.01.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, ymhungry.lee@samsung.com,
        j-young.choi@samsung.com
Subject: [RFC PATCH] scsi: ufs: alloc_mctx can be static
Message-ID: <20200321165021.GA39745@9de2199640c6>
References: <20200321004156.23364-6-beanhuo@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321004156.23364-6-beanhuo@micron.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Fixes: 161f01e2ffea ("scsi: ufs: UFS Host Performance Booster(HPB) driver")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 ufshpb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 137d0e3cf7261..ee77c7db668e7 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -29,7 +29,7 @@
 /*
  * debug variables
  */
-int alloc_mctx;
+static int alloc_mctx;
 
 /*
  * define global constants
