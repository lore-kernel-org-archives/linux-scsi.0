Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71037C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 22:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27F6260240
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 22:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhCQWym (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 18:54:42 -0400
Received: from mga07.intel.com ([134.134.136.100]:47152 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhCQWyX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Mar 2021 18:54:23 -0400
IronPort-SDR: wlizUNRAzQgR19OWeYOl8z2PKb0nY7jOmLjbEacVJiaT2IVCQMIixb4tdgyPeUU/rYVbMSC+kJ
 j4//z8iH/u7w==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="253571505"
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="253571505"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 15:54:23 -0700
IronPort-SDR: ASwbiLKsd30lU7VnETPpYOrZIj0Fo3LBq85QeST7tI0QXTHaST2fBixZgHF+DOjdBaUEi9UlW5
 uneBRLIz6Z9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="374333136"
Received: from lkp-server02.sh.intel.com (HELO 1c294c63cb86) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 17 Mar 2021 15:54:20 -0700
Received: from kbuild by 1c294c63cb86 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lMf3U-0000tU-Aq; Wed, 17 Mar 2021 22:54:20 +0000
Date:   Thu, 18 Mar 2021 06:53:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     kbuild-all@lists.01.org, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, kiran-kumar.kasturi@broadcom.com,
        sankar.patra@broadcom.com, sasikumar.pc@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [RFC PATCH] megaraid_sas: megasas_set_sdev_removed_by_fw can be
 static
Message-ID: <20210317225325.GA48350@453058ecf1e7>
References: <20210317190824.3050-4-chandrakanth.patil@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317190824.3050-4-chandrakanth.patil@broadcom.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 megaraid_sas_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f3716f7e1d105..09a8b37eb425a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3498,7 +3498,7 @@ megasas_complete_abort(struct megasas_instance *instance,
 	}
 }
 
-void
+static void
 megasas_set_sdev_removed_by_fw(struct megasas_instance *instance)
 {
 	struct scsi_device *sdev;
