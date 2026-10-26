Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793040311;
	b=hQKKSxh+zSSVvsWt4paMqOmSITSp2YMnt/qGMGoTVX3IrlLsywga6Zpn9VIGg39ldJxz
	 jNyl6UgeWo9VgTVetWnELMpRACD9xl9AueJjKueHomPPJRuM5khMl5eBFyWunoWw+An+G
	 yu+klizyPOIjjrYGKV+6OS+pq7nkn0I8Aoi43EfhmHAEGGaF6dFhLb1uUkMqT/6PJTeed
	 NelJpZEvQvezRIVxbKNT1dDSpTkWrI1Cq4SliizWgLqJATa/brkz+XencFnIzwlWUWUyM
	 xp3xl7AuQJekCQ47DurmlfSk2KhLk5//i9Dfl87P+Z1L34ov5lyUCYqKiTXbpl+wt8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793040311;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=ZeGR/RFj9I+8zbXav9PMrUJIC+FKJ+w79EZoNyp2nEk=;
	b=KkDmV80TUuuduHim3ac06Zjj8Z3bmYJCil0mHwT1o2OJAlAnNs0vf4w0dvrlHqcYYfYJ
	 454SbPERQ6dySlendL5RkSDVak9vIZkloZm+md3dtEZxxDbaM43Zw8Pvm/Ytf2uw507Cu
	 pbKgabnDio3C1GDbSDfWLhjuplyPTYIcNzXiRs10IJIlGX9aue6seOCTkza77TCYILDAk
	 PQwzcTcazpjdn35J1AwmYb5rSqOrCb/F8wuOfKAj+L/g5AV/1vJfvFwPWWF0OFpCIj9WH
	 Tmaxi1D7o+GpIruJbto/xMftX5mcRY6Wba23s2cWwVCZ/sYQxLXp/3AdeV977qIMFvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jamqsoD4;
	arc=none smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59947606A31F;
	Mon, 26 Oct 2026 18:45:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59947606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jamqsoD4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793040309; x=1824576309;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N0NGXzhFNrSgbXuqB5Y8clcdubkq8t9/rmNwRAxMgxk=;
  b=jamqsoD4XDnUf+xAj3SWMBW+V9QWxKkc8rSWc/skSZH9ncRWNC8MJduS
   yEAT3KA1rEofGUxCTcqCx5prnu113QfIlr5eQA3BSua3ekkglZ1pnIdrP
   h0yBK3f4faQvj5u0pNfkAUlikhHsG3rw/PkreqhEQS29bJmYd4aIahO1o
   jpU/vf94HwkjH8hJJ4TdUFTNXauUgriFqa1UIAjB/Dnpz7B6oD0aYVadP
   w295xMvmfr1byqwhW73/2rjAu+mrx+qC8rwMjBK+k59TOyKVsaSIga4St
   A1vTAc39qTM0rRNg/lvtkzA/BQMrqIv711ZCcvNL1V1FgNo0q53/uWXpG
   g==;
X-CSE-ConnectionGUID: +YCLFAIJQhmLUQEsKrje6w==
X-CSE-MsgGUID: 87eKxR0PQ6S7kBBYUD9yeA==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1609541"
X-IronPort-AV: E=Sophos;i="6.27,179,1787036400"; 
   d="scan'208";a="1609541"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 11:45:09 -0700
X-CSE-ConnectionGUID: ffOp329WSG61Q/qkoe9CQg==
X-CSE-MsgGUID: vclyqPY0SKyhJPgG1ZyQ7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,179,1787036400"; 
   d="scan'208";a="6201734"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa011.fm.intel.com with ESMTP; 26 Oct 2026 11:45:05 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xLPgs-00000000WMF-2Cw2;
	Mon, 26 Oct 2026 18:45:02 +0000
Date: Tue, 27 Oct 2026 02:44:26 +0800
From: kernel test robot <lkp@intel.com>
To: HOYOUNG SEO <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
	avri.altman@wdc.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	bvanassche@acm.org, kwangwon.min@samsung.com, kwmad.kim@samsung.com,
	cpgs@samsung.com, h10.kim@samsung.com
Cc: oe-kbuild-all@lists.linux.dev, HOYOUNG SEO <hy50.seo@samsung.com>
Subject: Re: [PATCH v4] scsi: ufs: Change the error check sequence for auto
 hibern8
Message-ID: <202610270253.MSZEgXih-lkp@intel.com>
References: <20261026052632.1848929-1-hy50.seo@samsung.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026052632.1848929-1-hy50.seo@samsung.com>

Hi HOYOUNG,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master next-20261023]
[cannot apply to linux-review/HOYOUNG-SEO/scsi-ufs-Change-the-error-check-sequence-for-auto-hibern8/20261022-164249 v7.3]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/HOYOUNG-SEO/scsi-ufs-Change-the-error-check-sequence-for-auto-hibern8/20261026-142632
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20261026052632.1848929-1-hy50.seo%40samsung.com
patch subject: [PATCH v4] scsi: ufs: Change the error check sequence for auto hibern8
config: sh-randconfig-1001-20261026 (https://download.01.org/0day-ci/archive/20261027/202610270253.MSZEgXih-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 13.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261027/202610270253.MSZEgXih-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610270253.MSZEgXih-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   drivers/ufs/core/ufshcd.c: In function 'ufshcd_uic_cmd_compl':
>> drivers/ufs/core/ufshcd.c:6032:13: error: invalid storage class for function '__ufshcd_transfer_req_compl'
    6032 | static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6046:13: error: invalid storage class for function 'ufshcd_clear_polled'
    6046 | static void ufshcd_clear_polled(struct ufs_hba *hba,
         |             ^~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6065:12: error: invalid storage class for function 'ufshcd_poll'
    6065 | static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
         |            ^~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6097:13: error: invalid storage class for function 'ufshcd_mcq_force_compl_one'
    6097 | static bool ufshcd_mcq_force_compl_one(struct request *rq, void *priv)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6134:13: error: invalid storage class for function 'ufshcd_mcq_compl_pending_transfer'
    6134 | static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6159:20: error: invalid storage class for function 'ufshcd_transfer_req_compl'
    6159 | static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6234:19: error: invalid storage class for function 'ufshcd_disable_ee'
    6234 | static inline int ufshcd_disable_ee(struct ufs_hba *hba, u16 mask)
         |                   ^~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6249:19: error: invalid storage class for function 'ufshcd_enable_ee'
    6249 | static inline int ufshcd_enable_ee(struct ufs_hba *hba, u16 mask)
         |                   ^~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6266:12: error: invalid storage class for function 'ufshcd_enable_auto_bkops'
    6266 | static int ufshcd_enable_auto_bkops(struct ufs_hba *hba)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6306:12: error: invalid storage class for function 'ufshcd_disable_auto_bkops'
    6306 | static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6350:13: error: invalid storage class for function 'ufshcd_force_reset_auto_bkops'
    6350 | static void ufshcd_force_reset_auto_bkops(struct ufs_hba *hba)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6365:19: error: invalid storage class for function 'ufshcd_get_bkops_status'
    6365 | static inline int ufshcd_get_bkops_status(struct ufs_hba *hba, u32 *status)
         |                   ^~~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6386:12: error: invalid storage class for function 'ufshcd_bkops_ctrl'
    6386 | static int ufshcd_bkops_ctrl(struct ufs_hba *hba)
         |            ^~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6412:19: error: invalid storage class for function 'ufshcd_get_ee_status'
    6412 | static inline int ufshcd_get_ee_status(struct ufs_hba *hba, u32 *status)
         |                   ^~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6418:13: error: invalid storage class for function 'ufshcd_bkops_exception_event_handler'
    6418 | static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6455:12: error: invalid storage class for function '__ufshcd_wb_toggle'
    6455 | static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn idn)
         |            ^~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6487:13: error: invalid storage class for function 'ufshcd_wb_toggle_buf_flush_during_h8'
    6487 | static void ufshcd_wb_toggle_buf_flush_during_h8(struct ufs_hba *hba,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6540:13: error: invalid storage class for function 'ufshcd_wb_curr_buff_threshold_check'
    6540 | static bool ufshcd_wb_curr_buff_threshold_check(struct ufs_hba *hba,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6566:13: error: invalid storage class for function 'ufshcd_wb_force_disable'
    6566 | static void ufshcd_wb_force_disable(struct ufs_hba *hba)
         |             ^~~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:6578:13: error: invalid storage class for function 'ufshcd_is_wb_buf_lifetime_available'
    6578 | static bool ufshcd_is_wb_buf_lifetime_available(struct ufs_hba *hba)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6607:13: error: invalid storage class for function 'ufshcd_wb_need_flush'
    6607 | static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
         |             ^~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6646:13: error: invalid storage class for function 'ufshcd_rpm_dev_flush_recheck_work'
    6646 | static void ufshcd_rpm_dev_flush_recheck_work(struct work_struct *work)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6668:13: error: invalid storage class for function 'ufshcd_exception_event_handler'
    6668 | static void ufshcd_exception_event_handler(struct work_struct *work)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6704:13: error: invalid storage class for function 'ufshcd_complete_requests'
    6704 | static void ufshcd_complete_requests(struct ufs_hba *hba, bool force_compl)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6721:13: error: invalid storage class for function 'ufshcd_quirk_dl_nac_errors'
    6721 | static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6786:20: error: invalid storage class for function 'ufshcd_is_saved_err_fatal'
    6786 | static inline bool ufshcd_is_saved_err_fatal(struct ufs_hba *hba)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from arch/sh/include/asm/bug.h:5,
                    from include/linux/bug.h:5,
                    from include/linux/instrumented.h:10,
                    from include/linux/atomic/atomic-instrumented.h:17,
                    from include/linux/atomic.h:82,
                    from include/asm-generic/bitops/atomic.h:5,
                    from arch/sh/include/asm/bitops.h:23,
                    from include/linux/bitops.h:67,
                    from include/linux/bitmap.h:8,
                    from include/linux/nodemask.h:91,
                    from include/linux/numa.h:6,
                    from include/linux/async.h:13,
                    from drivers/ufs/core/ufshcd.c:12:
   drivers/ufs/core/ufshcd.c:6814:19: error: non-static declaration of 'ufshcd_force_error_recovery' follows static declaration
    6814 | EXPORT_SYMBOL_GPL(ufshcd_force_error_recovery);
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:76:28: note: in definition of macro '__EXPORT_SYMBOL'
      76 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:90:41: note: in expansion of macro '_EXPORT_SYMBOL'
      90 | #define EXPORT_SYMBOL_GPL(sym)          _EXPORT_SYMBOL(sym, "GPL")
         |                                         ^~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6814:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    6814 | EXPORT_SYMBOL_GPL(ufshcd_force_error_recovery);
         | ^~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6807:6: note: previous definition of 'ufshcd_force_error_recovery' with type 'void(struct ufs_hba *)'
    6807 | void ufshcd_force_error_recovery(struct ufs_hba *hba)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6816:13: error: invalid storage class for function 'ufshcd_clk_scaling_allow'
    6816 | static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6825:13: error: invalid storage class for function 'ufshcd_clk_scaling_suspend'
    6825 | static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6838:13: error: invalid storage class for function 'ufshcd_err_handling_prepare'
    6838 | static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6882:13: error: invalid storage class for function 'ufshcd_err_handling_unprepare'
    6882 | static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6893:20: error: invalid storage class for function 'ufshcd_err_handling_should_stop'
    6893 | static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6950:20: error: invalid storage class for function 'ufshcd_recover_pm_error'
    6950 | static inline void ufshcd_recover_pm_error(struct ufs_hba *hba)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6955:13: error: invalid storage class for function 'ufshcd_is_pwr_mode_restore_needed'
    6955 | static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6971:13: error: invalid storage class for function 'ufshcd_abort_one'
    6971 | static bool ufshcd_abort_one(struct request *rq, void *priv)
         |             ^~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:6997:13: error: invalid storage class for function 'ufshcd_abort_all'
    6997 | static bool ufshcd_abort_all(struct ufs_hba *hba)
         |             ^~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:7023:13: error: invalid storage class for function 'ufshcd_err_handler'
    7023 | static void ufshcd_err_handler(struct work_struct *work)
         |             ^~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:7230:20: error: invalid storage class for function 'ufshcd_update_uic_error'
    7230 | static irqreturn_t ufshcd_update_uic_error(struct ufs_hba *hba)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:7332:20: error: invalid storage class for function 'ufshcd_check_errors'
    7332 | static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
         |                    ^~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:7409:20: error: invalid storage class for function 'ufshcd_tmc_handler'
    7409 | static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
         |                    ^~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:7437:20: error: invalid storage class for function 'ufshcd_handle_mcq_cq_events'
    7437 | static irqreturn_t ufshcd_handle_mcq_cq_events(struct ufs_hba *hba, bool reset_iag)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:7480:20: error: invalid storage class for function 'ufshcd_sl_intr'
    7480 | static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
         |                    ^~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:7514:20: error: invalid storage class for function 'ufshcd_intr'
    7514 | static irqreturn_t ufshcd_intr(int irq, void *__hba)
         |                    ^~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:7553:12: error: invalid storage class for function 'ufshcd_clear_tm_cmd'
    7553 | static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
         |            ^~~~~~~~~~~~~~~~~~~


vim +/__ufshcd_transfer_req_compl +6032 drivers/ufs/core/ufshcd.c

c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6026  
c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6027  /**
c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6028   * __ufshcd_transfer_req_compl - handle SCSI and query command completion
c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6029   * @hba: per adapter instance
c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6030   * @completed_reqs: bitmask that indicates which requests to complete
c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6031   */
c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13 @6032  static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6033  					unsigned long completed_reqs)
c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6034  {
c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6035  	int tag;
c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6036  
c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6037  	for_each_set_bit(tag, &completed_reqs, hba->nutrs)
c30d8d010b5efd drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6038  		ufshcd_compl_one_cqe(hba, tag, NULL);
a45f937110fa6b drivers/scsi/ufs/ufshcd.c Can Guo               2021-05-24  6039  }
7a3e97b0dc4bba drivers/scsi/ufs/ufshcd.c Santosh Yaraganavi    2012-02-29  6040  
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6041  /* Any value that is not an existing queue number is fine for this constant. */
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6042  enum {
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6043  	UFSHCD_POLL_FROM_INTERRUPT_CONTEXT = -1
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6044  };
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6045  
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18 @6046  static void ufshcd_clear_polled(struct ufs_hba *hba,
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6047  				unsigned long *completed_reqs)
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6048  {
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6049  	int tag;
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6050  
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6051  	for_each_set_bit(tag, completed_reqs, hba->nutrs) {
22089c218037ca drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6052  		struct scsi_cmnd *cmd = scsi_host_find_tag(hba->host, tag);
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6053  
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6054  		if (!cmd)
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6055  			continue;
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6056  		if (scsi_cmd_to_rq(cmd)->cmd_flags & REQ_POLLED)
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6057  			__clear_bit(tag, completed_reqs);
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6058  	}
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6059  }
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6060  
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6061  /*
3a17fefe0f1960 drivers/ufs/core/ufshcd.c Bart Van Assche       2023-07-27  6062   * Return: > 0 if one or more commands have been completed or 0 if no
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6063   * requests have been completed.
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6064   */
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03 @6065  static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6066  {
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6067  	struct ufs_hba *hba = shost_priv(shost);
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6068  	unsigned long completed_reqs, flags;
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6069  	u32 tr_doorbell;
ed975065c31c2a drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6070  	struct ufs_hw_queue *hwq;
ed975065c31c2a drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6071  
0fca3318e550d4 drivers/ufs/core/ufshcd.c Bart Van Assche       2024-07-08  6072  	if (hba->mcq_enabled) {
ccb23dc3435a0d drivers/ufs/core/ufshcd.c Po-Wen Kao            2023-06-10  6073  		hwq = &hba->uhq[queue_num];
ed975065c31c2a drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6074  
ed975065c31c2a drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6075  		return ufshcd_mcq_poll_cqe_lock(hba, hwq);
ed975065c31c2a drivers/ufs/core/ufshcd.c Asutosh Das           2023-01-13  6076  	}
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6077  
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6078  	spin_lock_irqsave(&hba->outstanding_lock, flags);
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6079  	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6080  	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6081  	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6082  		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6083  		  hba->outstanding_reqs);
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6084  	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6085  		/* Do not complete polled requests from interrupt context. */
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6086  		ufshcd_clear_polled(hba, &completed_reqs);
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6087  	}
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6088  	hba->outstanding_reqs &= ~completed_reqs;
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6089  	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6090  
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6091  	if (completed_reqs)
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6092  		__ufshcd_transfer_req_compl(hba, completed_reqs);
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6093  
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6094  	return completed_reqs != 0;
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6095  }
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6096  
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31 @6097  static bool ufshcd_mcq_force_compl_one(struct request *rq, void *priv)
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6098  {
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6099  	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6100  	struct scsi_device *sdev = rq->q->queuedata;
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6101  	struct Scsi_Host *shost = sdev->host;
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6102  	struct ufs_hba *hba = shost_priv(shost);
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6103  	struct ufs_hw_queue *hwq = ufshcd_mcq_req_to_hwq(hba, rq);
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6104  
4b6c0d9cca359d drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6105  	if (blk_mq_is_reserved_rq(rq) || !hwq)
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6106  		return true;
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6107  
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6108  	/*
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6109  	 * For those cmds of which the cqes are not present in the cq, complete
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6110  	 * them explicitly.
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6111  	 */
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6112  	scoped_guard(spinlock_irqsave, &hwq->cq_lock) {
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6113  		if (!test_bit(SCMD_STATE_COMPLETE, &cmd->state)) {
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6114  			set_host_byte(cmd, DID_REQUEUE);
22089c218037ca drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6115  			ufshcd_release_scsi_cmd(hba, cmd);
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6116  			scsi_done(cmd);
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6117  		}
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6118  	}
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6119  
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6120  	return true;
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6121  }
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6122  
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen         2023-05-29  6123  /**
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen         2023-05-29  6124   * ufshcd_mcq_compl_pending_transfer - MCQ mode function. It is
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen         2023-05-29  6125   * invoked from the error handler context or ufshcd_host_reset_and_restore()
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen         2023-05-29  6126   * to complete the pending transfers and free the resources associated with
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen         2023-05-29  6127   * the scsi command.
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen         2023-05-29  6128   *
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen         2023-05-29  6129   * @hba: per adapter instance
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen         2023-05-29  6130   * @force_compl: This flag is set to true when invoked
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen         2023-05-29  6131   * from ufshcd_host_reset_and_restore() in which case it requires special
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen         2023-05-29  6132   * handling because the host controller has been reset by ufshcd_hba_stop().
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen         2023-05-29  6133   */
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen         2023-05-29 @6134  static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen         2023-05-29  6135  					      bool force_compl)
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen         2023-05-29  6136  {
469fa055664bfd drivers/ufs/core/ufshcd.c Stanley Jhu           2026-09-28  6137  	int i;
469fa055664bfd drivers/ufs/core/ufshcd.c Stanley Jhu           2026-09-28  6138  
469fa055664bfd drivers/ufs/core/ufshcd.c Stanley Jhu           2026-09-28  6139  	for (i = 0; i < hba->nr_hw_queues; i++) {
469fa055664bfd drivers/ufs/core/ufshcd.c Stanley Jhu           2026-09-28  6140  		if (force_compl)
469fa055664bfd drivers/ufs/core/ufshcd.c Stanley Jhu           2026-09-28  6141  			ufshcd_mcq_compl_all_cqes_lock(hba, &hba->uhq[i]);
469fa055664bfd drivers/ufs/core/ufshcd.c Stanley Jhu           2026-09-28  6142  		else
469fa055664bfd drivers/ufs/core/ufshcd.c Stanley Jhu           2026-09-28  6143  			ufshcd_mcq_poll_cqe_lock(hba, &hba->uhq[i]);
469fa055664bfd drivers/ufs/core/ufshcd.c Stanley Jhu           2026-09-28  6144  	}
469fa055664bfd drivers/ufs/core/ufshcd.c Stanley Jhu           2026-09-28  6145  
469fa055664bfd drivers/ufs/core/ufshcd.c Stanley Jhu           2026-09-28  6146  	if (force_compl)
63a5b959c854c3 drivers/ufs/core/ufshcd.c Bart Van Assche       2025-10-31  6147  		blk_mq_tagset_busy_iter(&hba->host->tag_set,
469fa055664bfd drivers/ufs/core/ufshcd.c Stanley Jhu           2026-09-28  6148  					ufshcd_mcq_force_compl_one, NULL);
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen         2023-05-29  6149  }
ab248643d3d68b drivers/ufs/core/ufshcd.c Bao D. Nguyen         2023-05-29  6150  
9a47ec7c390e81 drivers/scsi/ufs/ufshcd.c Yaniv Gardi           2016-03-10  6151  /**
1f522c5049016c drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-07-21  6152   * ufshcd_transfer_req_compl - handle SCSI and query command completion
9a47ec7c390e81 drivers/scsi/ufs/ufshcd.c Yaniv Gardi           2016-03-10  6153   * @hba: per adapter instance
9333d77573485c drivers/scsi/ufs/ufshcd.c Venkat Gopalakrishnan 2019-11-14  6154   *
3a17fefe0f1960 drivers/ufs/core/ufshcd.c Bart Van Assche       2023-07-27  6155   * Return:
9333d77573485c drivers/scsi/ufs/ufshcd.c Venkat Gopalakrishnan 2019-11-14  6156   *  IRQ_HANDLED - If interrupt is valid
9333d77573485c drivers/scsi/ufs/ufshcd.c Venkat Gopalakrishnan 2019-11-14  6157   *  IRQ_NONE    - If invalid interrupt
9a47ec7c390e81 drivers/scsi/ufs/ufshcd.c Yaniv Gardi           2016-03-10  6158   */
11682523573c1c drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-10-20 @6159  static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
9a47ec7c390e81 drivers/scsi/ufs/ufshcd.c Yaniv Gardi           2016-03-10  6160  {
9a47ec7c390e81 drivers/scsi/ufs/ufshcd.c Yaniv Gardi           2016-03-10  6161  	/* Resetting interrupt aggregation counters first and reading the
9a47ec7c390e81 drivers/scsi/ufs/ufshcd.c Yaniv Gardi           2016-03-10  6162  	 * DOOR_BELL afterward allows us to handle all the completed requests.
9a47ec7c390e81 drivers/scsi/ufs/ufshcd.c Yaniv Gardi           2016-03-10  6163  	 * In order to prevent other interrupts starvation the DB is read once
9a47ec7c390e81 drivers/scsi/ufs/ufshcd.c Yaniv Gardi           2016-03-10  6164  	 * after reset. The down side of this solution is the possibility of
9a47ec7c390e81 drivers/scsi/ufs/ufshcd.c Yaniv Gardi           2016-03-10  6165  	 * false interrupt if device completes another request after resetting
9a47ec7c390e81 drivers/scsi/ufs/ufshcd.c Yaniv Gardi           2016-03-10  6166  	 * aggregation and before reading the DB.
9a47ec7c390e81 drivers/scsi/ufs/ufshcd.c Yaniv Gardi           2016-03-10  6167  	 */
b638b5eb624bd5 drivers/scsi/ufs/ufshcd.c Alim Akhtar           2020-05-28  6168  	if (ufshcd_is_intr_aggr_allowed(hba) &&
b638b5eb624bd5 drivers/scsi/ufs/ufshcd.c Alim Akhtar           2020-05-28  6169  	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
9a47ec7c390e81 drivers/scsi/ufs/ufshcd.c Yaniv Gardi           2016-03-10  6170  		ufshcd_reset_intr_aggr(hba);
9a47ec7c390e81 drivers/scsi/ufs/ufshcd.c Yaniv Gardi           2016-03-10  6171  
045da3077bc57e drivers/ufs/core/ufshcd.c Akinobu Mita          2023-11-18  6172  	if (ufs_fail_completion(hba))
c11a1ae9b8f65e drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-07-21  6173  		return IRQ_HANDLED;
c11a1ae9b8f65e drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-07-21  6174  
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6175  	/*
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6176  	 * Ignore the ufshcd_poll() return value and return IRQ_HANDLED since we
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6177  	 * do not want polling to trigger spurious interrupt complaints.
eaab9b57305496 drivers/scsi/ufs/ufshcd.c Bart Van Assche       2021-12-03  6178  	 */
ee8c88cab4afbd drivers/ufs/core/ufshcd.c Bart Van Assche       2022-11-18  6179  	ufshcd_poll(hba->host, UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
9a47ec7c390e81 drivers/scsi/ufs/ufshcd.c Yaniv Gardi           2016-03-10  6180  
9333d77573485c drivers/scsi/ufs/ufshcd.c Venkat Gopalakrishnan 2019-11-14  6181  	return IRQ_HANDLED;
9a47ec7c390e81 drivers/scsi/ufs/ufshcd.c Yaniv Gardi           2016-03-10  6182  }
9a47ec7c390e81 drivers/scsi/ufs/ufshcd.c Yaniv Gardi           2016-03-10  6183  
7deedfdaeccfec drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6184  int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask)
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6185  {
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6186  	return ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6187  				       QUERY_ATTR_IDN_EE_CONTROL, 0, 0,
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6188  				       &ee_ctrl_mask);
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6189  }
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6190  
7deedfdaeccfec drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6191  int ufshcd_write_ee_control(struct ufs_hba *hba)
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6192  {
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6193  	int err;
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6194  
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6195  	mutex_lock(&hba->ee_ctrl_mutex);
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6196  	err = __ufshcd_write_ee_control(hba, hba->ee_ctrl_mask);
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6197  	mutex_unlock(&hba->ee_ctrl_mutex);
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6198  	if (err)
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6199  		dev_err(hba->dev, "%s: failed to write ee control %d\n",
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6200  			__func__, err);
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6201  	return err;
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6202  }
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6203  
35d11ec239e099 drivers/ufs/core/ufshcd.c Krzysztof Kozlowski   2022-06-23 @6204  int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask,
35d11ec239e099 drivers/ufs/core/ufshcd.c Krzysztof Kozlowski   2022-06-23  6205  			     const u16 *other_mask, u16 set, u16 clr)
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6206  {
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6207  	u16 new_mask, ee_ctrl_mask;
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6208  	int err = 0;
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6209  
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6210  	mutex_lock(&hba->ee_ctrl_mutex);
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6211  	new_mask = (*mask & ~clr) | set;
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6212  	ee_ctrl_mask = new_mask | *other_mask;
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6213  	if (ee_ctrl_mask != hba->ee_ctrl_mask)
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6214  		err = __ufshcd_write_ee_control(hba, ee_ctrl_mask);
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6215  	/* Still need to update 'mask' even if 'ee_ctrl_mask' was unchanged */
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6216  	if (!err) {
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6217  		hba->ee_ctrl_mask = ee_ctrl_mask;
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6218  		*mask = new_mask;
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6219  	}
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6220  	mutex_unlock(&hba->ee_ctrl_mutex);
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6221  	return err;
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6222  }
cd4694756188dc drivers/scsi/ufs/ufshcd.c Adrian Hunter         2021-02-09  6223  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
