Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC23C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 09:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E055D2073C
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 09:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731049AbgKXJZc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 04:25:32 -0500
Received: from mga05.intel.com ([192.55.52.43]:39469 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730978AbgKXJZb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Nov 2020 04:25:31 -0500
IronPort-SDR: fFsplXvqGdqdHRICksXvhRwFSAgDZmESfEbZpijkjZDRxaw1Q8ItHGVHeM/iQHzlgGXpSD+4nO
 q1EggF74j7NQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="256626005"
X-IronPort-AV: E=Sophos;i="5.78,365,1599548400"; 
   d="scan'208";a="256626005"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 01:25:30 -0800
IronPort-SDR: yjd1ttVGe7q5aEFcaLKsLaG4VQi3t0CO+IdbXyIlHWaQCfrr+jpF8UlLCQXLELNBmKqeP6LFCR
 JSuDqOHI7TCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,365,1599548400"; 
   d="scan'208";a="361802438"
Received: from lkp-server01.sh.intel.com (HELO 2820ec516a85) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 24 Nov 2020 01:25:28 -0800
Received: from kbuild by 2820ec516a85 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1khUZk-00003M-7s; Tue, 24 Nov 2020 09:25:28 +0000
Date:   Tue, 24 Nov 2020 17:25:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     kbuild-all@lists.01.org, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [RFC PATCH] mpt3sas: _config_set_driver_trigger_pg1 can be static
Message-ID: <20201124092519.GA40025@0656867f41c5>
References: <20201124035019.27975-4-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124035019.27975-4-suganath-prabu.subramani@broadcom.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 mpt3sas_config.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 86d1643a74cd6b..15bbd6f9ae1019 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -1923,7 +1923,7 @@ mpt3sas_config_get_driver_trigger_pg1(struct MPT3SAS_ADAPTER *ioc,
  *
  * Returns 0 for success, non-zero for failure.
  */
-int
+static int
 _config_set_driver_trigger_pg1(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage1_t *config_page)
 {
