Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29EE1C001B1
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Jun 2023 11:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjFYLWo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Jun 2023 07:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjFYLWn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jun 2023 07:22:43 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BE2133;
        Sun, 25 Jun 2023 04:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687692162; x=1719228162;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P5wq7VRknPIaKF+xK/Zcd6WKbaEpZYPaK3pHNCT0o2g=;
  b=DtUpB2o62GQ5tyaYHMw8hwovgaCx5hbpQBIc9tZlGHHEO8mTLh19PEGH
   CCLybsmiTCzY1ze8ahvNP+yNxEBgqRyeb8UAeOi0FqrgDCtcxL+sQjWCe
   w9OO6IHQmdo0QehXpgiA/cgWJQkmz5KaZg2P2ymnXMaXm6dr1EM+tuH18
   mvJrl9udBSCbjgr+RvfK4XOLwmG2hB3TIV+WMoHXQn1mUTLKeHf/pWds6
   NIWtYbnxjCJ0Xsw5b8rIS0lVEELlPcS7Gt8xm0gmc7BcfxrKr9fE2Sd9z
   b3OKyPUL3ILSGrTaZvo3/WQ81Hv6G1JFO87evZTb8AALFoUicgqPygzFx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10751"; a="350822445"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="350822445"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2023 04:22:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10751"; a="839964891"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="839964891"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 25 Jun 2023 04:22:39 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qDNpG-0009zN-2p;
        Sun, 25 Jun 2023 11:22:38 +0000
Date:   Sun, 25 Jun 2023 19:22:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Rong Tao <rtoax@foxmail.com>, martin.petersen@oracle.com
Cc:     oe-kbuild-all@lists.linux.dev, rongtao@cestc.cn,
        Jonathan Corbet <corbet@lwn.net>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] docs: target: Remove useless tcm_mod_builder.py
Message-ID: <202306251958.viSgFQIV-lkp@intel.com>
References: <tencent_E3643D5F0AA8CCBEF28C6A233A18B808CD0A@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_E3643D5F0AA8CCBEF28C6A233A18B808CD0A@qq.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Rong,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on linus/master v6.4-rc7 next-20230623]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Rong-Tao/docs-target-Remove-useless-tcm_mod_builder-py/20230625-085229
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/tencent_E3643D5F0AA8CCBEF28C6A233A18B808CD0A%40qq.com
patch subject: [PATCH v2] docs: target: Remove useless tcm_mod_builder.py
reproduce: (https://download.01.org/0day-ci/archive/20230625/202306251958.viSgFQIV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306251958.viSgFQIV-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Documentation/target/scripts.rst:4: WARNING: Include file 'Documentation/target/tcm_mod_builder.py' not found or reading it failed

vim +4 Documentation/target/scripts.rst

4ca9bc225e46eb Mauro Carvalho Chehab 2019-06-12  3  
4ca9bc225e46eb Mauro Carvalho Chehab 2019-06-12 @4  .. literalinclude:: tcm_mod_builder.py
4ca9bc225e46eb Mauro Carvalho Chehab 2019-06-12  5      :language: perl
4ca9bc225e46eb Mauro Carvalho Chehab 2019-06-12  6  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
