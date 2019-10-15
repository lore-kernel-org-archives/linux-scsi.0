Return-Path: <SRS0=R+5F=YI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABFDAC10F14
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 18:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EF9520663
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 18:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbfJOS6o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Oct 2019 14:58:44 -0400
Received: from mga07.intel.com ([134.134.136.100]:54873 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727923AbfJOS6o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Oct 2019 14:58:44 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 11:58:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,300,1566889200"; 
   d="scan'208";a="194605549"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 15 Oct 2019 11:58:42 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iKS1p-000CcQ-Iy; Wed, 16 Oct 2019 02:58:41 +0800
Date:   Wed, 16 Oct 2019 02:58:07 +0800
From:   kbuild test robot <lkp@intel.com>
To:     balsundar.p@microsemi.com
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        jejb@linux.vnet.ibm.com, aacraid@microsemi.com
Subject: [RFC PATCH] scsi: aacraid: aac_schedule_bus_scan() can be static
Message-ID: <20191015185807.gkfkf44bc7accjua@332d0cec05f4>
References: <1571120524-6037-7-git-send-email-balsundar.p@microsemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571120524-6037-7-git-send-email-balsundar.p@microsemi.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Fixes: ffcdda7d81b4 ("scsi: aacraid: send AIF request post IOP RESET")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 commsup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 1c3beea2b3c57..5a8a999606ea3 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1464,7 +1464,7 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 	}
 }
 
-void aac_schedule_bus_scan(struct aac_dev *aac)
+static void aac_schedule_bus_scan(struct aac_dev *aac)
 {
 	if (aac->sa_firmware)
 		aac_schedule_safw_scan_worker(aac);
