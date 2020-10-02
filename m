Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1151DC4727D
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 12:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCC6E20672
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 12:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387873AbgJBMl0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 08:41:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:36769 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387814AbgJBMlY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Oct 2020 08:41:24 -0400
IronPort-SDR: jpUlthmS/x82UmtFyfZikwqzsZNBtE0JbTEZQDobhXwZlMd2H9EQcZCShelQti5nfZggFN2cjO
 zXURw4wqB0eQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="181105706"
X-IronPort-AV: E=Sophos;i="5.77,327,1596524400"; 
   d="scan'208";a="181105706"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 05:41:19 -0700
IronPort-SDR: cNkGByDMj+bxgWDWsnbaEQA40lRY+p9PB3Ej8vAv1xbDPU0HXmeTdbvUSql1KHE3qESzmsubHF
 P6Wt9VTm0rPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,327,1596524400"; 
   d="scan'208";a="352362849"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.190])
  by orsmga007.jf.intel.com with ESMTP; 02 Oct 2020 05:41:16 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 0/2] scsi: ufs: Add DeepSleep feature
Date:   Fri,  2 Oct 2020 15:40:41 +0300
Message-Id: <20201002124043.25394-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

Here is a patch to add DeepSleep, and a patch to workaround an issue hit
when testing.


Adrian Hunter (2):
      scsi: ufs: Add DeepSleep feature
      scsi: ufs: Workaround UFS devices that object to DeepSleep IMMED

 drivers/scsi/ufs/ufs-sysfs.c |  7 ++++
 drivers/scsi/ufs/ufs.h       |  1 +
 drivers/scsi/ufs/ufshcd.c    | 86 +++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufshcd.h    | 28 ++++++++++++++-
 include/trace/events/ufs.h   |  3 +-
 5 files changed, 119 insertions(+), 6 deletions(-)


Regards
Adrian
