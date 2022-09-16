Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FA1ECAAD8
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 10:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiIPKw6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Sep 2022 06:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbiIPKwj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2022 06:52:39 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2455C120C
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2022 03:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663324310; x=1694860310;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=H4HMzAXQx8OcEbNbzfEB64yRWytdwOjsmdf4VHWyBAU=;
  b=dU+YLjZsshOGUR6Y02qioc9EDMUmUxXcTIfOJliIlNflvvci2+4AIEOM
   8sRlL5yqyzeap743t6COPhxIq/T0hYEM/bRrnNjb+hEkTV2NS3EiS3k4p
   ZlY7U0B9Sx6fT862NOyAL4HjLx5+c++5nlkbk8w3wC8O5PmKoe90ERxNL
   nwHA5K6On7YIvv8TBxJH3wqw73mZoyPeMpq6YbCcT0Vvxknm9EkXoVDe6
   4Cjw2dI02vaE39kmpFKmCWBoQ7FmOVIljEWyWpZIRDliMBGo/p4Gnyogy
   /d+vgQoKE1iglgIC38AcLkKBLA844W94aqFdJNvATxyfqSaQTFRi1x/Qb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="360703259"
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="360703259"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2022 03:31:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="946331759"
Received: from lkp-server02.sh.intel.com (HELO 41300c7200ea) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 16 Sep 2022 03:31:47 -0700
Received: from kbuild by 41300c7200ea with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oZ8dP-0001h4-17;
        Fri, 16 Sep 2022 10:31:47 +0000
Date:   Fri, 16 Sep 2022 18:31:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: [jejb-scsi:for-next 5/5]
 drivers/scsi/mpt3sas/mpt3sas_base.c:2992:24: warning: unused variable 's'
Message-ID: <202209161807.ElaiKIxS-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
head:   82472fa2e160c47a429783b6f45d375d3253fbaf
commit: 82472fa2e160c47a429783b6f45d375d3253fbaf [5/5] Merge branch 'fixes' into for-next
config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/20220916/202209161807.ElaiKIxS-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/commit/?id=82472fa2e160c47a429783b6f45d375d3253fbaf
        git remote add jejb-scsi https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
        git fetch --no-tags jejb-scsi for-next
        git checkout 82472fa2e160c47a429783b6f45d375d3253fbaf
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/scsi/mpt3sas/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/scsi/mpt3sas/mpt3sas_base.c: In function '_base_config_dma_addressing':
   drivers/scsi/mpt3sas/mpt3sas_base.c:2995:9: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
    2995 |         if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4 ||
         |         ^~
   drivers/scsi/mpt3sas/mpt3sas_base.c:2998:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
    2998 |                 coherent_dma_mask = dma_mask = DMA_BIT_MASK(32);
         |                 ^~~~~~~~~~~~~~~~~
   drivers/scsi/mpt3sas/mpt3sas_base.c:2993:13: warning: variable 'coherent_dma_mask' set but not used [-Wunused-but-set-variable]
    2993 |         u64 coherent_dma_mask, dma_mask;
         |             ^~~~~~~~~~~~~~~~~
>> drivers/scsi/mpt3sas/mpt3sas_base.c:2992:24: warning: unused variable 's' [-Wunused-variable]
    2992 |         struct sysinfo s;
         |                        ^
   drivers/scsi/mpt3sas/mpt3sas_base.c:3000:9: error: no return statement in function returning non-void [-Werror=return-type]
    3000 |         } else if (ioc->hba_mpi_version_belonged > MPI2_VERSION) {
         |         ^
   drivers/scsi/mpt3sas/mpt3sas_base.c: At top level:
   drivers/scsi/mpt3sas/mpt3sas_base.c:3000:11: error: expected identifier or '(' before 'else'
    3000 |         } else if (ioc->hba_mpi_version_belonged > MPI2_VERSION) {
         |           ^~~~
   drivers/scsi/mpt3sas/mpt3sas_base.c:3003:11: error: expected identifier or '(' before 'else'
    3003 |         } else {
         |           ^~~~
   drivers/scsi/mpt3sas/mpt3sas_base.c:3008:9: error: expected identifier or '(' before 'if'
    3008 |         if (ioc->use_32bit_dma)
         |         ^~
   drivers/scsi/mpt3sas/mpt3sas_base.c:3011:9: error: expected identifier or '(' before 'if'
    3011 |         if (dma_set_mask(&pdev->dev, dma_mask) ||
         |         ^~
   drivers/scsi/mpt3sas/mpt3sas_base.c:3015:9: error: expected identifier or '(' before 'if'
    3015 |         if (ioc->dma_mask > 32) {
         |         ^~
   drivers/scsi/mpt3sas/mpt3sas_base.c:3018:11: error: expected identifier or '(' before 'else'
    3018 |         } else {
         |           ^~~~
   drivers/scsi/mpt3sas/mpt3sas_base.c:3023:20: error: expected declaration specifiers or '...' before '&' token
    3023 |         si_meminfo(&s);
         |                    ^
   In file included from include/linux/kernel.h:29,
                    from drivers/scsi/mpt3sas/mpt3sas_base.c:46:
   include/linux/printk.h:434:10: error: expected identifier or '(' before '{' token
     434 |         ({                                                              \
         |          ^
   include/linux/printk.h:464:26: note: in expansion of macro 'printk_index_wrap'
     464 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                          ^~~~~~~~~~~~~~~~~
   include/linux/printk.h:537:9: note: in expansion of macro 'printk'
     537 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   drivers/scsi/mpt3sas/mpt3sas_base.h:189:9: note: in expansion of macro 'pr_info'
     189 |         pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
         |         ^~~~~~~
   drivers/scsi/mpt3sas/mpt3sas_base.c:3024:9: note: in expansion of macro 'ioc_info'
    3024 |         ioc_info(ioc, "%d BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (%ld kB)\n",
         |         ^~~~~~~~
   drivers/scsi/mpt3sas/mpt3sas_base.c:3027:9: error: expected identifier or '(' before 'return'
    3027 |         return 0;
         |         ^~~~~~
   drivers/scsi/mpt3sas/mpt3sas_base.c:3028:1: error: expected identifier or '(' before '}' token
    3028 | }
         | ^
   drivers/scsi/mpt3sas/mpt3sas_base.c:2106:1: warning: '_base_add_sg_single_64' defined but not used [-Wunused-function]
    2106 | _base_add_sg_single_64(void *paddr, u32 flags_length, dma_addr_t dma_addr)
         | ^~~~~~~~~~~~~~~~~~~~~~
   drivers/scsi/mpt3sas/mpt3sas_base.c:2088:1: warning: '_base_add_sg_single_32' defined but not used [-Wunused-function]
    2088 | _base_add_sg_single_32(void *paddr, u32 flags_length, dma_addr_t dma_addr)
         | ^~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/s +2992 drivers/scsi/mpt3sas/mpt3sas_base.c

f92363d1235949 Sreekanth Reddy   2012-11-30  2981  
f92363d1235949 Sreekanth Reddy   2012-11-30  2982  /**
f92363d1235949 Sreekanth Reddy   2012-11-30  2983   * _base_config_dma_addressing - set dma addressing
f92363d1235949 Sreekanth Reddy   2012-11-30  2984   * @ioc: per adapter object
f92363d1235949 Sreekanth Reddy   2012-11-30  2985   * @pdev: PCI device struct
f92363d1235949 Sreekanth Reddy   2012-11-30  2986   *
4beb4867f049ae Bart Van Assche   2018-06-15  2987   * Return: 0 for success, non-zero for failure.
f92363d1235949 Sreekanth Reddy   2012-11-30  2988   */
f92363d1235949 Sreekanth Reddy   2012-11-30  2989  static int
f92363d1235949 Sreekanth Reddy   2012-11-30  2990  _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
f92363d1235949 Sreekanth Reddy   2012-11-30  2991  {
f92363d1235949 Sreekanth Reddy   2012-11-30 @2992  	struct sysinfo s;
9df650963bf6d6 Sreekanth Reddy   2022-08-25  2993  	u64 coherent_dma_mask, dma_mask;
1c2048bdc3f4ff Christoph Hellwig 2018-10-11  2994  
9df650963bf6d6 Sreekanth Reddy   2022-08-25  2995  	if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4 ||
e0e0747de0ea3d Sreekanth Reddy   2022-09-13  2996  	    dma_get_required_mask(&pdev->dev) <= DMA_BIT_MASK(32))
d6adc251dd2fed Suganath Prabu S  2021-03-05  2997  		ioc->dma_mask = 32;
9df650963bf6d6 Sreekanth Reddy   2022-08-25  2998  		coherent_dma_mask = dma_mask = DMA_BIT_MASK(32);
ba27c5cf286df0 Christoph Hellwig 2020-04-23  2999  	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
9df650963bf6d6 Sreekanth Reddy   2022-08-25  3000  	} else if (ioc->hba_mpi_version_belonged > MPI2_VERSION) {
d6adc251dd2fed Suganath Prabu S  2021-03-05  3001  		ioc->dma_mask = 63;
9df650963bf6d6 Sreekanth Reddy   2022-08-25  3002  		coherent_dma_mask = dma_mask = DMA_BIT_MASK(63);
9df650963bf6d6 Sreekanth Reddy   2022-08-25  3003  	} else {
d6adc251dd2fed Suganath Prabu S  2021-03-05  3004  		ioc->dma_mask = 64;
9df650963bf6d6 Sreekanth Reddy   2022-08-25  3005  		coherent_dma_mask = dma_mask = DMA_BIT_MASK(64);
9df650963bf6d6 Sreekanth Reddy   2022-08-25  3006  	}
9df650963bf6d6 Sreekanth Reddy   2022-08-25  3007  
9df650963bf6d6 Sreekanth Reddy   2022-08-25  3008  	if (ioc->use_32bit_dma)
9df650963bf6d6 Sreekanth Reddy   2022-08-25  3009  		coherent_dma_mask = DMA_BIT_MASK(32);
1c2048bdc3f4ff Christoph Hellwig 2018-10-11  3010  
9df650963bf6d6 Sreekanth Reddy   2022-08-25  3011  	if (dma_set_mask(&pdev->dev, dma_mask) ||
9df650963bf6d6 Sreekanth Reddy   2022-08-25  3012  	    dma_set_coherent_mask(&pdev->dev, coherent_dma_mask))
ba27c5cf286df0 Christoph Hellwig 2020-04-23  3013  		return -ENODEV;
1c2048bdc3f4ff Christoph Hellwig 2018-10-11  3014  
d6adc251dd2fed Suganath Prabu S  2021-03-05  3015  	if (ioc->dma_mask > 32) {
f92363d1235949 Sreekanth Reddy   2012-11-30  3016  		ioc->base_add_sg_single = &_base_add_sg_single_64;
f92363d1235949 Sreekanth Reddy   2012-11-30  3017  		ioc->sge_size = sizeof(Mpi2SGESimple64_t);
ba27c5cf286df0 Christoph Hellwig 2020-04-23  3018  	} else {
f92363d1235949 Sreekanth Reddy   2012-11-30  3019  		ioc->base_add_sg_single = &_base_add_sg_single_32;
f92363d1235949 Sreekanth Reddy   2012-11-30  3020  		ioc->sge_size = sizeof(Mpi2SGESimple32_t);
ba27c5cf286df0 Christoph Hellwig 2020-04-23  3021  	}
ba27c5cf286df0 Christoph Hellwig 2020-04-23  3022  
f92363d1235949 Sreekanth Reddy   2012-11-30  3023  	si_meminfo(&s);
919d8a3f3fef99 Joe Perches       2018-09-17  3024  	ioc_info(ioc, "%d BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (%ld kB)\n",
d6adc251dd2fed Suganath Prabu S  2021-03-05  3025  		ioc->dma_mask, convert_to_kb(s.totalram));
f92363d1235949 Sreekanth Reddy   2012-11-30  3026  
f92363d1235949 Sreekanth Reddy   2012-11-30  3027  	return 0;
f92363d1235949 Sreekanth Reddy   2012-11-30  3028  }
f92363d1235949 Sreekanth Reddy   2012-11-30  3029  

:::::: The code at line 2992 was first introduced by commit
:::::: f92363d12359498f9a9960511de1a550f0ec41c2 [SCSI] mpt3sas: add new driver supporting 12GB SAS

:::::: TO: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
:::::: CC: James Bottomley <JBottomley@Parallels.com>

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
