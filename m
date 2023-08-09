Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFB3C001DE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 02:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjHICpx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Aug 2023 22:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjHICpw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2023 22:45:52 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542301BF5
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2023 19:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691549149; x=1723085149;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=dw7Z82mrna/pwAIi3OaabiM4HH9+hjghJwDMqGVaIzs=;
  b=l2jT3WE49UQIx5hHQMIuFVkspBZ8sflRQu9wh314jtVmN+eyOYC9vChF
   FCbPrnCHVnhrgad9O1dqWDZmgnLGm7BXi2CO3htbOtp85TGGGQ8loQgSG
   482jYvxEfMXuZMqfZVZiVfBCyy0i7KlNiqKGr+DlRKyisjdsfRLm5D80e
   DzZ/XcdZeRqM5ND/5jgh38fwGZGNG8T5jxmJ+byfOiQTjY7MHZ94x43/T
   sRVwSUWP6F7jt3J67i1gHlbZPac519+6/TINzsCyCVVB1DGQMSANzPiuk
   PgngJXgwVs0a54itsTKYpTCn6KxSnaqvoLMhRpWE/dbSi4z5karFLftwk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="457385720"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="457385720"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 19:45:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="731633609"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="731633609"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 08 Aug 2023 19:45:20 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qTZCJ-0005ko-1u;
        Wed, 09 Aug 2023 02:45:19 +0000
Date:   Wed, 9 Aug 2023 10:44:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [jejb-scsi:misc 36/37] drivers/ufs/host/ufs-qcom.c:64:3: sparse:
 sparse: symbol 'ufs_qcom_bw_table' was not declared. Should it be static?
Message-ID: <202308091030.L5JrOBJB-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
head:   6cae9a3910ac1b5daf5ac3db9576b78cc4eff5aa
commit: 03ce80a1bb869f735de793f04c9c085b61884599 [36/37] scsi: ufs: qcom: Add support for scaling interconnects
config: arm64-randconfig-r071-20230808 (https://download.01.org/0day-ci/archive/20230809/202308091030.L5JrOBJB-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230809/202308091030.L5JrOBJB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308091030.L5JrOBJB-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/ufs/host/ufs-qcom.c:64:3: sparse: sparse: symbol 'ufs_qcom_bw_table' was not declared. Should it be static?

vim +/ufs_qcom_bw_table +64 drivers/ufs/host/ufs-qcom.c

    60	
    61	struct __ufs_qcom_bw_table {
    62		u32 mem_bw;
    63		u32 cfg_bw;
  > 64	} ufs_qcom_bw_table[MODE_MAX + 1][QCOM_UFS_MAX_GEAR + 1][QCOM_UFS_MAX_LANE + 1] = {
    65		[MODE_MIN][0][0]		   = { 0,		0 }, /* Bandwidth values in KB/s */
    66		[MODE_PWM][UFS_PWM_G1][UFS_LANE_1] = { 922,		1000 },
    67		[MODE_PWM][UFS_PWM_G2][UFS_LANE_1] = { 1844,		1000 },
    68		[MODE_PWM][UFS_PWM_G3][UFS_LANE_1] = { 3688,		1000 },
    69		[MODE_PWM][UFS_PWM_G4][UFS_LANE_1] = { 7376,		1000 },
    70		[MODE_PWM][UFS_PWM_G1][UFS_LANE_2] = { 1844,		1000 },
    71		[MODE_PWM][UFS_PWM_G2][UFS_LANE_2] = { 3688,		1000 },
    72		[MODE_PWM][UFS_PWM_G3][UFS_LANE_2] = { 7376,		1000 },
    73		[MODE_PWM][UFS_PWM_G4][UFS_LANE_2] = { 14752,		1000 },
    74		[MODE_HS_RA][UFS_HS_G1][UFS_LANE_1] = { 127796,		1000 },
    75		[MODE_HS_RA][UFS_HS_G2][UFS_LANE_1] = { 255591,		1000 },
    76		[MODE_HS_RA][UFS_HS_G3][UFS_LANE_1] = { 1492582,	102400 },
    77		[MODE_HS_RA][UFS_HS_G4][UFS_LANE_1] = { 2915200,	204800 },
    78		[MODE_HS_RA][UFS_HS_G1][UFS_LANE_2] = { 255591,		1000 },
    79		[MODE_HS_RA][UFS_HS_G2][UFS_LANE_2] = { 511181,		1000 },
    80		[MODE_HS_RA][UFS_HS_G3][UFS_LANE_2] = { 1492582,	204800 },
    81		[MODE_HS_RA][UFS_HS_G4][UFS_LANE_2] = { 2915200,	409600 },
    82		[MODE_HS_RB][UFS_HS_G1][UFS_LANE_1] = { 149422,		1000 },
    83		[MODE_HS_RB][UFS_HS_G2][UFS_LANE_1] = { 298189,		1000 },
    84		[MODE_HS_RB][UFS_HS_G3][UFS_LANE_1] = { 1492582,	102400 },
    85		[MODE_HS_RB][UFS_HS_G4][UFS_LANE_1] = { 2915200,	204800 },
    86		[MODE_HS_RB][UFS_HS_G1][UFS_LANE_2] = { 298189,		1000 },
    87		[MODE_HS_RB][UFS_HS_G2][UFS_LANE_2] = { 596378,		1000 },
    88		[MODE_HS_RB][UFS_HS_G3][UFS_LANE_2] = { 1492582,	204800 },
    89		[MODE_HS_RB][UFS_HS_G4][UFS_LANE_2] = { 2915200,	409600 },
    90		[MODE_MAX][0][0]		    = { 7643136,	307200 },
    91	};
    92	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
