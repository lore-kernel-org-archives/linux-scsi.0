Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E89A0C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 12:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B86F2076B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 12:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733249AbgKXMGr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 07:06:47 -0500
Received: from mga07.intel.com ([134.134.136.100]:14649 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731223AbgKXMGr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Nov 2020 07:06:47 -0500
IronPort-SDR: ns1qvaQr4XYDi7gHH2NvXUA3skU9FS/nO0b1QJcJD9MKicXiEy4rcpnx1WkbILfyqIPrtNLRbC
 KMzbabksqzoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="236070066"
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="236070066"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 04:06:46 -0800
IronPort-SDR: CvNA4ClJKi8O6lBKiCT85npltOAkkULBBWeQblrCS0AYh7Zk/KeL/4SgxTgwZ8MbE5Uc+sZ8eo
 89TUU/rSm/mA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="313231452"
Received: from lkp-server01.sh.intel.com (HELO 2820ec516a85) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 24 Nov 2020 04:06:43 -0800
Received: from kbuild by 2820ec516a85 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1khX5n-00005i-7v; Tue, 24 Nov 2020 12:06:43 +0000
Date:   Tue, 24 Nov 2020 20:05:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     kbuild-all@lists.01.org, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [RFC PATCH] mpt3sas: _config_set_driver_trigger_pg4 can be static
Message-ID: <20201124120546.GA44725@0656867f41c5>
References: <20201124035019.27975-7-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124035019.27975-7-suganath-prabu.subramani@broadcom.com>
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
index c3aaaab15b311c..8726f448d81c4d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -2391,7 +2391,7 @@ mpt3sas_config_get_driver_trigger_pg4(struct MPT3SAS_ADAPTER *ioc,
  *
  * Returns 0 for success, non-zero for failure.
  */
-int
+static int
 _config_set_driver_trigger_pg4(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage4_t *config_page)
 {
