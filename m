Return-Path: <SRS0=R+5F=YI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F12ECE58C
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 18:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 990B420663
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 18:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbfJOS6n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Oct 2019 14:58:43 -0400
Received: from mga17.intel.com ([192.55.52.151]:38973 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727923AbfJOS6n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Oct 2019 14:58:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 11:58:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,300,1566889200"; 
   d="scan'208";a="185907524"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 15 Oct 2019 11:58:41 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iKS1o-000CYK-Pp; Wed, 16 Oct 2019 02:58:40 +0800
Date:   Wed, 16 Oct 2019 02:58:07 +0800
From:   kbuild test robot <lkp@intel.com>
To:     balsundar.p@microsemi.com
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        jejb@linux.vnet.ibm.com, aacraid@microsemi.com
Subject: Re: [PATCH 6/7] scsi: aacraid: send AIF request post IOP RESET
Message-ID: <201910160237.a47j4Ua4%lkp@intel.com>
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

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on scsi/for-next]
[cannot apply to v5.4-rc3 next-20191014]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/balsundar-p-microsemi-com/scsi-aacraid-updates/20191015-142326
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/scsi/aacraid/commsup.c:1467:6: sparse: sparse: symbol 'aac_schedule_bus_scan' was not declared. Should it be static?
   drivers/scsi/aacraid/commsup.c:2385:5: sparse: sparse: symbol 'aac_send_safw_hostttime' was not declared. Should it be static?
   drivers/scsi/aacraid/commsup.c:2414:5: sparse: sparse: symbol 'aac_send_hosttime' was not declared. Should it be static?
   drivers/scsi/aacraid/commsup.c:599:17: sparse: sparse: context imbalance in 'aac_fib_send' - different lock contexts for basic block
   drivers/scsi/aacraid/commsup.c:754:17: sparse: sparse: context imbalance in 'aac_hba_send' - different lock contexts for basic block
   drivers/scsi/aacraid/commsup.c:1502:32: sparse: sparse: context imbalance in '_aac_reset_adapter' - unexpected unlock

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
