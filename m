Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14ABDCA9ED1
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 16:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE8992084D
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 16:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfKBQVK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Nov 2019 12:21:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:6202 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfKBQVK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 2 Nov 2019 12:21:10 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Nov 2019 09:21:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,259,1569308400"; 
   d="scan'208";a="204783265"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 02 Nov 2019 09:21:08 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iQw9D-000AdL-Ek; Sun, 03 Nov 2019 00:21:07 +0800
Date:   Sun, 3 Nov 2019 00:20:20 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     kbuild-all@lists.01.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] aacraid: use blk_mq_rq_busy_iter() for traversing
 outstanding commands
Message-ID: <201911030002.QxP2N1jT%lkp@intel.com>
References: <20191101111838.140027-4-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101111838.140027-4-hare@suse.de>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hannes,

I love your patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on next-20191031]
[cannot apply to v5.4-rc5]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Hannes-Reinecke/scsi-remove-legacy-cmd_list-implementation/20191102-214752
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


coccinelle warnings: (new ones prefixed by >>)

>> drivers/scsi/aacraid/aachba.c:2699:15-16: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
