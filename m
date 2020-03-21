Return-Path: <SRS0=d7EE=5G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F3BAC4332D
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 16:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CE1220732
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 16:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgCUQus (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Mar 2020 12:50:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:45121 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgCUQuq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 21 Mar 2020 12:50:46 -0400
IronPort-SDR: SZdw5Icw6hRsD+xZ4BSdTI4Ir7f1+NPy17ZfwzpYgDfDSwzKwfq8kCB0hPZ/qAd/s3gSJH/HJP
 JdZL2H9mpfKg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 09:50:45 -0700
IronPort-SDR: RsUwU7+ECsn/OucOfZm6zqnltDD9TfdwJQnMe8mXmRrNxdUZ4tsi+JIVBKwb3tcX/35ktM7TnK
 YMcl8iXN4Ijg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,289,1580803200"; 
   d="scan'208";a="239519730"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 21 Mar 2020 09:50:41 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jFhKa-0003Kr-Uj; Sun, 22 Mar 2020 00:50:40 +0800
Date:   Sun, 22 Mar 2020 00:50:20 +0800
From:   kbuild test robot <lkp@intel.com>
To:     huobean@gmail.com
Cc:     kbuild-all@lists.01.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, ymhungry.lee@samsung.com,
        j-young.choi@samsung.com
Subject: Re: [PATCH v1 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
Message-ID: <202003220007.8idvF9WX%lkp@intel.com>
References: <20200321004156.23364-6-beanhuo@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321004156.23364-6-beanhuo@micron.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on scsi/for-next next-20200320]
[cannot apply to v5.6-rc6]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/huobean-gmail-com/scsi-ufs-add-UFS-Host-Performance-Booster-HPB-driver/20200321-084331
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-187-gbff9b106-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/scsi/ufs/ufshpb.c:32:5: sparse: sparse: symbol 'alloc_mctx' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
