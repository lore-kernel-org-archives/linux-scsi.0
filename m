Return-Path: <SRS0=2Pi9=YT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D462DCA9EBD
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Oct 2019 14:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4EB42070B
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Oct 2019 14:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfJZON1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Oct 2019 10:13:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:4865 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfJZON0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 26 Oct 2019 10:13:26 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Oct 2019 07:13:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,232,1569308400"; 
   d="scan'208";a="400387356"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 26 Oct 2019 07:13:24 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iOMom-0000iQ-Ah; Sat, 26 Oct 2019 22:13:24 +0800
Date:   Sat, 26 Oct 2019 22:13:04 +0800
From:   kbuild test robot <lkp@intel.com>
To:     James Smart <jsmart2021@gmail.com>
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [RFC PATCH] elx: efct: efct_libefc_templ can be static
Message-ID: <20191026141304.6bs2qp6hwhxjorw6@4978f4969bb8>
References: <20191023215557.12581-33-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023215557.12581-33-jsmart2021@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Fixes: 24d4401b1dd0 ("elx: efct: Tie into kernel Kconfig and build process")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 efct_driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
index 4928e5753d88c..b00fc00a6eb02 100644
--- a/drivers/scsi/elx/efct/efct_driver.c
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -46,7 +46,7 @@ struct efct_fw_write_result {
 	u32 change_status;
 };
 
-struct libefc_function_template efct_libefc_templ = {
+static struct libefc_function_template efct_libefc_templ = {
 	.hw_domain_alloc = efct_hw_domain_alloc,
 	.hw_domain_attach = efct_hw_domain_attach,
 	.hw_domain_free = efct_hw_domain_free,
