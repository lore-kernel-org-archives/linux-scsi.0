Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833E7C4742C
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 00:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 471BD2242C
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 00:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbgKDAzl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 19:55:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:24942 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728157AbgKDAzk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Nov 2020 19:55:40 -0500
IronPort-SDR: J6aP/rIvqqZ3m1kidGOdm2HXd3iOjUcGPqaHHwdcxJyX7ShuYBPs1LFCH89/qNqLz89lttcT7z
 56LfbuRlI7Yw==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="169284605"
X-IronPort-AV: E=Sophos;i="5.77,449,1596524400"; 
   d="gz'50?scan'50,208,50";a="169284605"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 16:55:39 -0800
IronPort-SDR: aGqdFLfVaNIg3VKz0e8W1J3N/6b8Hu2oho6VWgKVClrJXqDcRB5kNIUGvKgogUdkjyTFFL0XLn
 DtH+LXGKDhew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,449,1596524400"; 
   d="gz'50?scan'50,208,50";a="363802599"
Received: from lkp-server02.sh.intel.com (HELO e61783667810) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 03 Nov 2020 16:55:36 -0800
Received: from kbuild by e61783667810 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1ka75M-0000aR-0g; Wed, 04 Nov 2020 00:55:36 +0000
Date:   Wed, 4 Nov 2020 08:55:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     kbuild-all@lists.01.org, jsmart2021@gmail.com, emilne@redhat.com,
        mkumar@redhat.com, pbonzini@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: Re: [PATCH v3 19/19] scsi: Made changes in Kconfig to select
 BLK_CGROUP_FC_APPID
Message-ID: <202011040846.2AS0qfae-lkp@intel.com>
References: <1604387903-20006-20-git-send-email-muneendra.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <1604387903-20006-20-git-send-email-muneendra.kumar@broadcom.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Muneendra,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on scsi/for-next]
[also build test ERROR on cgroup/for-next v5.10-rc2]
[cannot apply to mkp-scsi/for-next next-20201103]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Muneendra/blkcg-Support-to-track-FC-storage-blk-io-traffic/20201103-221403
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
config: mips-rm200_defconfig (attached as .config)
compiler: mipsel-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/78074b9ba99b7f8c0cd4b2d0c17589441443775c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Muneendra/blkcg-Support-to-track-FC-storage-blk-io-traffic/20201103-221403
        git checkout 78074b9ba99b7f8c0cd4b2d0c17589441443775c
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=mips 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   WARNING: unmet direct dependencies detected for BLK_CGROUP_FC_APPID
   Depends on BLOCK && BLK_CGROUP
   Selected by
   - SCSI_FC_ATTRS && SCSI && NET
   In file included from include/linux/writeback.h:14,
   from include/linux/memcontrol.h:22,
   from include/linux/swap.h:9,
   from include/linux/suspend.h:5,
   from arch/mips/kernel/asm-offsets.c:17:
   include/linux/blk-cgroup.h: In function 'blkcg_set_fc_appid':
>> include/linux/blk-cgroup.h:686:8: error: implicit declaration of function 'cgroup_get_e_css'; did you mean
   686 | css = cgroup_get_e_css(cgrp, &io_cgrp_subsys);
   | ^~~~~~~~~~~~~~~~
   | cgroup_release
   include/linux/blk-cgroup.h:686:32: error: 'io_cgrp_subsys' undeclared (first use in this function)
   686 | css = cgroup_get_e_css(cgrp, &io_cgrp_subsys);
   | ^~~~~~~~~~~~~~
   include/linux/blk-cgroup.h:686:32: note: each undeclared identifier is reported only once for each function it appears in
   include/linux/blk-cgroup.h:691:10: error: implicit declaration of function 'css_to_blkcg'; did you mean
   691 | blkcg = css_to_blkcg(css);
   | ^~~~~~~~~~~~
   | pd_to_blkg
   include/linux/blk-cgroup.h:691:8: warning: assignment to 'struct blkcg from 'int' makes pointer from integer without a cast
   691 | blkcg = css_to_blkcg(css);
   | ^
   include/linux/blk-cgroup.h:700:15: error: 'struct blkcg' has no member named 'fc_app_id'
   700 | strlcpy(blkcg->fc_app_id, buf, len);
   | ^~
>> include/linux/blk-cgroup.h:704:2: error: implicit declaration of function 'cgroup_put'; did you mean
   704 | cgroup_put(cgrp);
   | ^~~~~~~~~~
   | cgroup_psi
   include/linux/blk-cgroup.h: In function 'blkcg_get_fc_appid':
   include/linux/blk-cgroup.h:719:16: error: 'struct bio' has no member named 'bi_blkg'
   719 | if (bio && bio->bi_blkg &&
   | ^~
   include/linux/blk-cgroup.h:720:14: error: 'struct bio' has no member named 'bi_blkg'
   720 | strlen(bio->bi_blkg->blkcg->fc_app_id))
   | ^~
   include/linux/blk-cgroup.h:721:13: error: 'struct bio' has no member named 'bi_blkg'
   721 | return bio->bi_blkg->blkcg->fc_app_id;
   | ^~
   arch/mips/kernel/asm-offsets.c: At top level:
   arch/mips/kernel/asm-offsets.c:26:6: warning: no previous prototype for 'output_ptreg_defines'
   26 | void output_ptreg_defines(void)
   | ^~~~~~~~~~~~~~~~~~~~
   arch/mips/kernel/asm-offsets.c:78:6: warning: no previous prototype for 'output_task_defines'
   78 | void output_task_defines(void)
   | ^~~~~~~~~~~~~~~~~~~
   arch/mips/kernel/asm-offsets.c:93:6: warning: no previous prototype for 'output_thread_info_defines'
   93 | void output_thread_info_defines(void)
   | ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/mips/kernel/asm-offsets.c:110:6: warning: no previous prototype for 'output_thread_defines'
   110 | void output_thread_defines(void)
   | ^~~~~~~~~~~~~~~~~~~~~
   arch/mips/kernel/asm-offsets.c:138:6: warning: no previous prototype for 'output_thread_fpu_defines'
   138 | void output_thread_fpu_defines(void)
   | ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/mips/kernel/asm-offsets.c:181:6: warning: no previous prototype for 'output_mm_defines'
   181 | void output_mm_defines(void)
   | ^~~~~~~~~~~~~~~~~
   arch/mips/kernel/asm-offsets.c:220:6: warning: no previous prototype for 'output_sc_defines'
   220 | void output_sc_defines(void)
   | ^~~~~~~~~~~~~~~~~
   arch/mips/kernel/asm-offsets.c:255:6: warning: no previous prototype for 'output_signal_defined'
   255 | void output_signal_defined(void)
   | ^~~~~~~~~~~~~~~~~~~~~
   arch/mips/kernel/asm-offsets.c:348:6: warning: no previous prototype for 'output_kvm_defines'
   348 | void output_kvm_defines(void)
   | ^~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
   Makefile arch include kernel scripts source usr [scripts/Makefile.build:117: arch/mips/kernel/asm-offsets.s] Error 1
   Target '__build' not remade because of errors.
   Makefile arch include kernel scripts source usr [Makefile:1200: prepare0] Error 2
   Target 'prepare' not remade because of errors.
   make: Makefile arch include kernel scripts source usr [Makefile:185: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.

vim +/cgroup_get_e_css +686 include/linux/blk-cgroup.h

835f4599c6dcff2 Muneendra 2020-11-03  668  
835f4599c6dcff2 Muneendra 2020-11-03  669  #ifdef CONFIG_BLK_CGROUP_FC_APPID
835f4599c6dcff2 Muneendra 2020-11-03  670  /*
835f4599c6dcff2 Muneendra 2020-11-03  671   * Sets the fc_app_id field associted to blkcg
835f4599c6dcff2 Muneendra 2020-11-03  672   * @buf: application identifier
835f4599c6dcff2 Muneendra 2020-11-03  673   * @id: cgrp id
835f4599c6dcff2 Muneendra 2020-11-03  674   * @len: size of appid
835f4599c6dcff2 Muneendra 2020-11-03  675   */
835f4599c6dcff2 Muneendra 2020-11-03  676  static inline int blkcg_set_fc_appid(char *buf, u64 id, size_t len)
835f4599c6dcff2 Muneendra 2020-11-03  677  {
835f4599c6dcff2 Muneendra 2020-11-03  678  	struct cgroup *cgrp = NULL;
835f4599c6dcff2 Muneendra 2020-11-03  679  	struct cgroup_subsys_state *css = NULL;
835f4599c6dcff2 Muneendra 2020-11-03  680  	struct blkcg *blkcg = NULL;
835f4599c6dcff2 Muneendra 2020-11-03  681  	int ret  = 0;
835f4599c6dcff2 Muneendra 2020-11-03  682  
835f4599c6dcff2 Muneendra 2020-11-03  683  	cgrp = cgroup_get_from_kernfs_id(id);
835f4599c6dcff2 Muneendra 2020-11-03  684  	if (!cgrp)
835f4599c6dcff2 Muneendra 2020-11-03  685  		return -ENOENT;
835f4599c6dcff2 Muneendra 2020-11-03 @686  	css = cgroup_get_e_css(cgrp, &io_cgrp_subsys);
835f4599c6dcff2 Muneendra 2020-11-03  687  	if (!css) {
835f4599c6dcff2 Muneendra 2020-11-03  688  		ret = -ENOENT;
835f4599c6dcff2 Muneendra 2020-11-03  689  		goto out_cgrp_put;
835f4599c6dcff2 Muneendra 2020-11-03  690  	}
835f4599c6dcff2 Muneendra 2020-11-03  691  	blkcg = css_to_blkcg(css);
835f4599c6dcff2 Muneendra 2020-11-03  692  	if (!blkcg) {
835f4599c6dcff2 Muneendra 2020-11-03  693  		ret = -ENOENT;
835f4599c6dcff2 Muneendra 2020-11-03  694  		goto out_put;
835f4599c6dcff2 Muneendra 2020-11-03  695  	}
835f4599c6dcff2 Muneendra 2020-11-03  696  	if (len > APPID_LEN) {
835f4599c6dcff2 Muneendra 2020-11-03  697  		ret = -EINVAL;
835f4599c6dcff2 Muneendra 2020-11-03  698  		goto out_put;
835f4599c6dcff2 Muneendra 2020-11-03  699  	}
835f4599c6dcff2 Muneendra 2020-11-03  700  	strlcpy(blkcg->fc_app_id, buf, len);
835f4599c6dcff2 Muneendra 2020-11-03  701  out_put:
835f4599c6dcff2 Muneendra 2020-11-03  702  	css_put(css);
835f4599c6dcff2 Muneendra 2020-11-03  703  out_cgrp_put:
835f4599c6dcff2 Muneendra 2020-11-03 @704  	cgroup_put(cgrp);
835f4599c6dcff2 Muneendra 2020-11-03  705  	return ret;
835f4599c6dcff2 Muneendra 2020-11-03  706  }
835f4599c6dcff2 Muneendra 2020-11-03  707  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--ReaqsoxgOBHFXBhH
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
bcQm1V03AP4AtkQ7bpo0AQA=

--ReaqsoxgOBHFXBhH--
