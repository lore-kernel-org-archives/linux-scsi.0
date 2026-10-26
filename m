Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793036704;
	b=TpPe3buN0io4xBafVkKlSmhAOfqLD0+KXlri0noLaoU3o6WDIKSmrFlRWAUIWHNa6Vdb
	 GNDR8gHt0yuW6aYQKs/XIsxTwnp60XzHXEOqxQMsfquOIkvA24xYkg7hS8e3ap4XoEoHA
	 PSZC4RFcNa/xMuk+V0Gdaw7GJl/D6a+e35Z4qiZjO7D4PYfFAysyr4Ago9fPY71/rcb9s
	 UQTnHSSX4aCV8oGB4rjriyVWnMaF21WbswbgzbgYf//1n/iNhe+L6wSH7hJtWOEDdlHmx
	 mUNyzg/8wxlXlq9h280pXzl330E7Dl8x2gn0TU3D/5ruQyFqARBb4uv7iZJAOZ46pGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793036704;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=4rBymZYRlVpC20zxEUdMVCi2UjggE3dTNG8vLqOWHOA=;
	b=xSXfEffRNeytjcg7JHIXoM1Th4qehb49SbYOgUo1j0GxLpfGRo7FGVsjvAidDfN4N3j5
	 dqVeH7KF8Arr+UFVUp6zptpt09N5WNu9I8HVTJOo16WAV6eZjS3RQwllN9pTRICLw+7N6
	 yXPFOivtHdQN6jCHMcEwee7P2PJfplqMiEhBPWU1WjwLjnwzxB+I1nPdYbuuqmlmbIxZv
	 zaqRXwbizjB4JTbA15qxVXq044+t9XSFPOFh/NzguJlPePZ5bToGUsH89GZjpmAynAKqS
	 niHttbdrlXWkq1uoQLkeLSWKS0jFopVHpE7CwfkK5FjeTqSxWc60x2c2/laYBYJf9BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=aLTUdMvF;
	arc=none smtp.remote-ip=198.175.65.19
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CA4606A31F;
	Mon, 26 Oct 2026 17:45:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7CA4606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=aLTUdMvF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793036701; x=1824572701;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WPDPspWMgaJQvfDBAe4hHHaJhXE/GgiZs0Qx9szJVwA=;
  b=aLTUdMvFTWChS3wzmChU8J+dhDGE6DBtLlS9Tsq3ecEMznMh2CKYueLS
   GGkeJvun1tQkQeDCDdeFrfM/duzfcyqXYtHJ1L2YAH01Cld9H+JImv4mj
   KexgaeMNsnJjvBhtQs8Mal6eiZnOx0xiTSFAy7AgqtXtgogNanql2zSR8
   KbHVUxCVq2lRFCFxckfyx26uO12eNjpEweyql1w+iiqO80TRw75OXubMn
   C9ZyIbQcS19/A2i0/W7tLp+WUg6yP63MlGUHM9PtZ3MfxlavSNrj/Uvaa
   AsGJtzGi08Zjdk4Lp0S3NODZXGmaBLDIYVmlvyZo8cuWdIlG5p+Xm7Muu
   A==;
X-CSE-ConnectionGUID: n8jM/yenSiCx3OCXHKwXwA==
X-CSE-MsgGUID: tSO+cbcCSqGYnxsg/lKDxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1745625"
X-IronPort-AV: E=Sophos;i="6.27,179,1787036400"; 
   d="scan'208";a="1745625"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 10:45:01 -0700
X-CSE-ConnectionGUID: 5Ub6x6TvR7Krsf51kIA9WA==
X-CSE-MsgGUID: CwCXg7ImQBu8x9nYALyfpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,179,1787036400"; 
   d="scan'208";a="4396703"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 26 Oct 2026 10:44:58 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xLOkh-00000000WHO-2fjX;
	Mon, 26 Oct 2026 17:44:55 +0000
Date: Tue, 27 Oct 2026 01:44:30 +0800
From: kernel test robot <lkp@intel.com>
To: HOYOUNG SEO <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
	avri.altman@wdc.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	bvanassche@acm.org, kwangwon.min@samsung.com, kwmad.kim@samsung.com,
	cpgs@samsung.com, h10.kim@samsung.com
Cc: oe-kbuild-all@lists.linux.dev, HOYOUNG SEO <hy50.seo@samsung.com>
Subject: Re: [PATCH v4] scsi: ufs: Change the error check sequence for auto
 hibern8
Message-ID: <202610270143.Imt9oS4A-lkp@intel.com>
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
config: i386-randconfig-1006-20261026 (https://download.01.org/0day-ci/archive/20261027/202610270143.Imt9oS4A-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261027/202610270143.Imt9oS4A-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610270143.Imt9oS4A-lkp@intel.com/

All errors (new ones prefixed by >>):

    9598 | static void ufshcd_async_scan(void *data, async_cookie_t cookie)
         |             ^~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9624:33: error: invalid storage class for function 'ufshcd_eh_timed_out'
    9624 | static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
         |                                 ^~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9695:35: error: initializer element is not constant
    9695 |         .mq_poll                = ufshcd_poll,
         |                                   ^~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9695:35: note: (near initialization for 'ufshcd_driver_template.mq_poll')
   drivers/ufs/core/ufshcd.c:9700:35: error: initializer element is not constant
    9700 |         .eh_abort_handler       = ufshcd_abort,
         |                                   ^~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9700:35: note: (near initialization for 'ufshcd_driver_template.eh_abort_handler')
   drivers/ufs/core/ufshcd.c:9701:36: error: initializer element is not constant
    9701 |         .eh_device_reset_handler = ufshcd_eh_device_reset_handler,
         |                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9701:36: note: (near initialization for 'ufshcd_driver_template.eh_device_reset_handler')
   drivers/ufs/core/ufshcd.c:9702:36: error: initializer element is not constant
    9702 |         .eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
         |                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9702:36: note: (near initialization for 'ufshcd_driver_template.eh_host_reset_handler')
   drivers/ufs/core/ufshcd.c:9703:35: error: initializer element is not constant
    9703 |         .eh_timed_out           = ufshcd_eh_timed_out,
         |                                   ^~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9703:35: note: (near initialization for 'ufshcd_driver_template.eh_timed_out')
   drivers/ufs/core/ufshcd.c:9715:12: error: invalid storage class for function 'ufshcd_config_vreg_load'
    9715 | static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
         |            ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9741:19: error: invalid storage class for function 'ufshcd_config_vreg_lpm'
    9741 | static inline int ufshcd_config_vreg_lpm(struct ufs_hba *hba,
         |                   ^~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9747:19: error: invalid storage class for function 'ufshcd_config_vreg_hpm'
    9747 | static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
         |                   ^~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9756:12: error: invalid storage class for function 'ufshcd_config_vreg'
    9756 | static int ufshcd_config_vreg(struct device *dev,
         |            ^~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9765:12: error: invalid storage class for function 'ufshcd_enable_vreg'
    9765 | static int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg *vreg)
         |            ^~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9785:12: error: invalid storage class for function 'ufshcd_disable_vreg'
    9785 | static int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg *vreg)
         |            ^~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9806:12: error: invalid storage class for function 'ufshcd_setup_vreg'
    9806 | static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on)
         |            ^~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9831:12: error: invalid storage class for function 'ufshcd_setup_hba_vreg'
    9831 | static int ufshcd_setup_hba_vreg(struct ufs_hba *hba, bool on)
         |            ^~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9854:19: error: non-static declaration of 'ufshcd_get_vreg' follows static declaration
    9854 | EXPORT_SYMBOL_GPL(ufshcd_get_vreg);
         |                   ^~~~~~~~~~~~~~~
   include/linux/export.h:76:28: note: in definition of macro '__EXPORT_SYMBOL'
      76 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:90:41: note: in expansion of macro '_EXPORT_SYMBOL'
      90 | #define EXPORT_SYMBOL_GPL(sym)          _EXPORT_SYMBOL(sym, "GPL")
         |                                         ^~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9854:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    9854 | EXPORT_SYMBOL_GPL(ufshcd_get_vreg);
         | ^~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9838:5: note: previous definition of 'ufshcd_get_vreg' with type 'int(struct device *, struct ufs_vreg *)'
    9838 | int ufshcd_get_vreg(struct device *dev, struct ufs_vreg *vreg)
         |     ^~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9856:12: error: invalid storage class for function 'ufshcd_init_vreg'
    9856 | static int ufshcd_init_vreg(struct ufs_hba *hba)
         |            ^~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9873:12: error: invalid storage class for function 'ufshcd_init_hba_vreg'
    9873 | static int ufshcd_init_hba_vreg(struct ufs_hba *hba)
         |            ^~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9880:12: error: invalid storage class for function 'ufshcd_setup_clocks'
    9880 | static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
         |            ^~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9948:30: error: invalid storage class for function 'ufshcd_parse_ref_clk_property'
    9948 | static enum ufs_ref_clk_freq ufshcd_parse_ref_clk_property(struct ufs_hba *hba)
         |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:9961:12: error: invalid storage class for function 'ufshcd_init_clocks'
    9961 | static int ufshcd_init_clocks(struct ufs_hba *hba)
         |            ^~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10019:12: error: invalid storage class for function 'ufshcd_variant_hba_init'
   10019 | static int ufshcd_variant_hba_init(struct ufs_hba *hba)
         |            ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10030:12: error: invalid storage class for function 'ufshcd_hba_init'
   10030 | static int ufshcd_hba_init(struct ufs_hba *hba)
         |            ^~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10088:13: error: invalid storage class for function 'ufshcd_hba_exit'
   10088 | static void ufshcd_hba_exit(struct ufs_hba *hba)
         |             ^~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10107:12: error: invalid storage class for function 'ufshcd_execute_start_stop'
   10107 | static int ufshcd_execute_start_stop(struct scsi_device *sdev,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10142:12: error: invalid storage class for function 'ufshcd_set_dev_pwr_mode'
   10142 | static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
         |            ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10193:12: error: invalid storage class for function 'ufshcd_link_state_transition'
   10193 | static int ufshcd_link_state_transition(struct ufs_hba *hba,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10251:13: error: invalid storage class for function 'ufshcd_vreg_set_lpm'
   10251 | static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
         |             ^~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:10302:12: error: invalid storage class for function 'ufshcd_vreg_set_hpm'
   10302 | static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)
         |            ^~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10343:13: error: invalid storage class for function 'ufshcd_hba_vreg_set_lpm'
   10343 | static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba)
         |             ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10349:13: error: invalid storage class for function 'ufshcd_hba_vreg_set_hpm'
   10349 | static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba)
         |             ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10355:12: error: invalid storage class for function '__ufshcd_wl_suspend'
   10355 | static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
         |            ^~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:10541:12: error: invalid storage class for function '__ufshcd_wl_resume'
   10541 | static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
         |            ^~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:10641:12: error: invalid storage class for function 'ufshcd_wl_runtime_suspend'
   10641 | static int ufshcd_wl_runtime_suspend(struct device *dev)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:10661:12: error: invalid storage class for function 'ufshcd_wl_runtime_resume'
   10661 | static int ufshcd_wl_runtime_resume(struct device *dev)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:10683:12: error: invalid storage class for function 'ufshcd_wl_suspend'
   10683 | static int ufshcd_wl_suspend(struct device *dev)
         |            ^~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:10712:12: error: invalid storage class for function 'ufshcd_wl_resume'
   10712 | static int ufshcd_wl_resume(struct device *dev)
         |            ^~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10747:12: error: invalid storage class for function 'ufshcd_suspend'
   10747 | static int ufshcd_suspend(struct ufs_hba *hba)
         |            ^~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:10789:12: error: invalid storage class for function 'ufshcd_resume'
   10789 | static int ufshcd_resume(struct ufs_hba *hba)
         |            ^~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:10846:15: error: non-static declaration of 'ufshcd_system_suspend' follows static declaration
   10846 | EXPORT_SYMBOL(ufshcd_system_suspend);
         |               ^~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:76:28: note: in definition of macro '__EXPORT_SYMBOL'
      76 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:89:41: note: in expansion of macro '_EXPORT_SYMBOL'
      89 | #define EXPORT_SYMBOL(sym)              _EXPORT_SYMBOL(sym, "")
         |                                         ^~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10846:1: note: in expansion of macro 'EXPORT_SYMBOL'
   10846 | EXPORT_SYMBOL(ufshcd_system_suspend);
         | ^~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10830:5: note: previous definition of 'ufshcd_system_suspend' with type 'int(struct device *)'
   10830 | int ufshcd_system_suspend(struct device *dev)
         |     ^~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:10875:15: error: non-static declaration of 'ufshcd_system_resume' follows static declaration
   10875 | EXPORT_SYMBOL(ufshcd_system_resume);
         |               ^~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:76:28: note: in definition of macro '__EXPORT_SYMBOL'
      76 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:89:41: note: in expansion of macro '_EXPORT_SYMBOL'
      89 | #define EXPORT_SYMBOL(sym)              _EXPORT_SYMBOL(sym, "")
         |                                         ^~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10875:1: note: in expansion of macro 'EXPORT_SYMBOL'
   10875 | EXPORT_SYMBOL(ufshcd_system_resume);
         | ^~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10857:5: note: previous definition of 'ufshcd_system_resume' with type 'int(struct device *)'
   10857 | int ufshcd_system_resume(struct device *dev)
         |     ^~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:10900:15: error: non-static declaration of 'ufshcd_runtime_suspend' follows static declaration
   10900 | EXPORT_SYMBOL(ufshcd_runtime_suspend);
         |               ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:76:28: note: in definition of macro '__EXPORT_SYMBOL'
      76 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:89:41: note: in expansion of macro '_EXPORT_SYMBOL'
      89 | #define EXPORT_SYMBOL(sym)              _EXPORT_SYMBOL(sym, "")
         |                                         ^~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10900:1: note: in expansion of macro 'EXPORT_SYMBOL'
   10900 | EXPORT_SYMBOL(ufshcd_runtime_suspend);
         | ^~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10887:5: note: previous definition of 'ufshcd_runtime_suspend' with type 'int(struct device *)'
   10887 | int ufshcd_runtime_suspend(struct device *dev)
         |     ^~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:10927:15: error: non-static declaration of 'ufshcd_runtime_resume' follows static declaration
   10927 | EXPORT_SYMBOL(ufshcd_runtime_resume);
         |               ^~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:76:28: note: in definition of macro '__EXPORT_SYMBOL'
      76 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:89:41: note: in expansion of macro '_EXPORT_SYMBOL'
      89 | #define EXPORT_SYMBOL(sym)              _EXPORT_SYMBOL(sym, "")
         |                                         ^~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10927:1: note: in expansion of macro 'EXPORT_SYMBOL'
   10927 | EXPORT_SYMBOL(ufshcd_runtime_resume);
         | ^~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10914:5: note: previous definition of 'ufshcd_runtime_resume' with type 'int(struct device *)'
   10914 | int ufshcd_runtime_resume(struct device *dev)
         |     ^~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10930:13: error: invalid storage class for function 'ufshcd_wl_shutdown'
   10930 | static void ufshcd_wl_shutdown(struct scsi_device *sdev)
         |             ^~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10987:19: error: non-static declaration of 'ufshcd_remove' follows static declaration
   10987 | EXPORT_SYMBOL_GPL(ufshcd_remove);
         |                   ^~~~~~~~~~~~~
   include/linux/export.h:76:28: note: in definition of macro '__EXPORT_SYMBOL'
      76 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:90:41: note: in expansion of macro '_EXPORT_SYMBOL'
      90 | #define EXPORT_SYMBOL_GPL(sym)          _EXPORT_SYMBOL(sym, "GPL")
         |                                         ^~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10987:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
   10987 | EXPORT_SYMBOL_GPL(ufshcd_remove);
         | ^~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10968:6: note: previous definition of 'ufshcd_remove' with type 'void(struct ufs_hba *)'
   10968 | void ufshcd_remove(struct ufs_hba *hba)
         |      ^~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:10996:19: error: non-static declaration of 'ufshcd_system_freeze' follows static declaration
   10996 | EXPORT_SYMBOL_GPL(ufshcd_system_freeze);
         |                   ^~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:76:28: note: in definition of macro '__EXPORT_SYMBOL'
      76 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:90:41: note: in expansion of macro '_EXPORT_SYMBOL'
      90 | #define EXPORT_SYMBOL_GPL(sym)          _EXPORT_SYMBOL(sym, "GPL")
         |                                         ^~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10996:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
   10996 | EXPORT_SYMBOL_GPL(ufshcd_system_freeze);
         | ^~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10990:5: note: previous definition of 'ufshcd_system_freeze' with type 'int(struct device *)'
   10990 | int ufshcd_system_freeze(struct device *dev)
         |     ^~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:11027:19: error: non-static declaration of 'ufshcd_system_restore' follows static declaration
   11027 | EXPORT_SYMBOL_GPL(ufshcd_system_restore);
         |                   ^~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:76:28: note: in definition of macro '__EXPORT_SYMBOL'
      76 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:90:41: note: in expansion of macro '_EXPORT_SYMBOL'
      90 | #define EXPORT_SYMBOL_GPL(sym)          _EXPORT_SYMBOL(sym, "GPL")
         |                                         ^~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11027:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
   11027 | EXPORT_SYMBOL_GPL(ufshcd_system_restore);
         | ^~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:10998:5: note: previous definition of 'ufshcd_system_restore' with type 'int(struct device *)'
   10998 | int ufshcd_system_restore(struct device *dev)
         |     ^~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:11033:19: error: non-static declaration of 'ufshcd_system_thaw' follows static declaration
   11033 | EXPORT_SYMBOL_GPL(ufshcd_system_thaw);
         |                   ^~~~~~~~~~~~~~~~~~
   include/linux/export.h:76:28: note: in definition of macro '__EXPORT_SYMBOL'
      76 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:90:41: note: in expansion of macro '_EXPORT_SYMBOL'
      90 | #define EXPORT_SYMBOL_GPL(sym)          _EXPORT_SYMBOL(sym, "GPL")
         |                                         ^~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11033:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
   11033 | EXPORT_SYMBOL_GPL(ufshcd_system_thaw);
         | ^~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11029:5: note: previous definition of 'ufshcd_system_thaw' with type 'int(struct device *)'
   11029 | int ufshcd_system_thaw(struct device *dev)
         |     ^~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11043:12: error: invalid storage class for function 'ufshcd_set_dma_mask'
   11043 | static int ufshcd_set_dma_mask(struct ufs_hba *hba)
         |            ^~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11059:13: error: invalid storage class for function 'ufshcd_devres_release'
   11059 | static void ufshcd_devres_release(void *host)
         |             ^~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11117:15: error: non-static declaration of 'ufshcd_alloc_host' follows static declaration
   11117 | EXPORT_SYMBOL(ufshcd_alloc_host);
         |               ^~~~~~~~~~~~~~~~~
   include/linux/export.h:76:28: note: in definition of macro '__EXPORT_SYMBOL'
      76 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:89:41: note: in expansion of macro '_EXPORT_SYMBOL'
      89 | #define EXPORT_SYMBOL(sym)              _EXPORT_SYMBOL(sym, "")
         |                                         ^~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11117:1: note: in expansion of macro 'EXPORT_SYMBOL'
   11117 | EXPORT_SYMBOL(ufshcd_alloc_host);
         | ^~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11075:5: note: previous definition of 'ufshcd_alloc_host' with type 'int(struct device *, struct ufs_hba **)'
   11075 | int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
         |     ^~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11120:21: error: invalid storage class for function 'ufshcd_queue_tmf'
   11120 | static blk_status_t ufshcd_queue_tmf(struct blk_mq_hw_ctx *hctx,
         |                     ^~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11128:21: error: initializer element is not constant
   11128 |         .queue_rq = ufshcd_queue_tmf,
         |                     ^~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11128:21: note: (near initialization for 'ufshcd_tmf_ops.queue_rq')
   drivers/ufs/core/ufshcd.c:11131:12: error: invalid storage class for function 'ufshcd_add_scsi_host'
   11131 | static int ufshcd_add_scsi_host(struct ufs_hba *hba)
         |            ^~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11468:19: error: non-static declaration of 'ufshcd_init' follows static declaration
   11468 | EXPORT_SYMBOL_GPL(ufshcd_init);
         |                   ^~~~~~~~~~~
   include/linux/export.h:76:28: note: in definition of macro '__EXPORT_SYMBOL'
      76 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:90:41: note: in expansion of macro '_EXPORT_SYMBOL'
      90 | #define EXPORT_SYMBOL_GPL(sym)          _EXPORT_SYMBOL(sym, "GPL")
         |                                         ^~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11468:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
   11468 | EXPORT_SYMBOL_GPL(ufshcd_init);
         | ^~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11207:5: note: previous definition of 'ufshcd_init' with type 'int(struct ufs_hba *, void *, unsigned int)'
   11207 | int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
         |     ^~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11479:19: error: non-static declaration of 'ufshcd_resume_complete' follows static declaration
   11479 | EXPORT_SYMBOL_GPL(ufshcd_resume_complete);
         |                   ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:76:28: note: in definition of macro '__EXPORT_SYMBOL'
      76 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:90:41: note: in expansion of macro '_EXPORT_SYMBOL'
      90 | #define EXPORT_SYMBOL_GPL(sym)          _EXPORT_SYMBOL(sym, "GPL")
         |                                         ^~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11479:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
   11479 | EXPORT_SYMBOL_GPL(ufshcd_resume_complete);
         | ^~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11470:6: note: previous definition of 'ufshcd_resume_complete' with type 'void(struct device *)'
   11470 | void ufshcd_resume_complete(struct device *dev)
         |      ^~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11481:13: error: invalid storage class for function 'ufshcd_rpm_ok_for_spm'
   11481 | static bool ufshcd_rpm_ok_for_spm(struct ufs_hba *hba)
         |             ^~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11531:19: error: non-static declaration of '__ufshcd_suspend_prepare' follows static declaration
   11531 | EXPORT_SYMBOL_GPL(__ufshcd_suspend_prepare);
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:76:28: note: in definition of macro '__EXPORT_SYMBOL'
      76 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:90:41: note: in expansion of macro '_EXPORT_SYMBOL'
      90 | #define EXPORT_SYMBOL_GPL(sym)          _EXPORT_SYMBOL(sym, "GPL")
         |                                         ^~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11531:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
   11531 | EXPORT_SYMBOL_GPL(__ufshcd_suspend_prepare);
         | ^~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11501:5: note: previous definition of '__ufshcd_suspend_prepare' with type 'int(struct device *, bool)' {aka 'int(struct device *, _Bool)'}
   11501 | int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm)
         |     ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11537:19: error: non-static declaration of 'ufshcd_suspend_prepare' follows static declaration
   11537 | EXPORT_SYMBOL_GPL(ufshcd_suspend_prepare);
         |                   ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:76:28: note: in definition of macro '__EXPORT_SYMBOL'
      76 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:90:41: note: in expansion of macro '_EXPORT_SYMBOL'
      90 | #define EXPORT_SYMBOL_GPL(sym)          _EXPORT_SYMBOL(sym, "GPL")
         |                                         ^~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11537:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
   11537 | EXPORT_SYMBOL_GPL(ufshcd_suspend_prepare);
         | ^~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11533:5: note: previous definition of 'ufshcd_suspend_prepare' with type 'int(struct device *)'
   11533 | int ufshcd_suspend_prepare(struct device *dev)
         |     ^~~~~~~~~~~~~~~~~~~~~~
>> drivers/ufs/core/ufshcd.c:11540:12: error: invalid storage class for function 'ufshcd_wl_poweroff'
   11540 | static int ufshcd_wl_poweroff(struct device *dev)
         |            ^~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11550:12: error: invalid storage class for function 'ufshcd_wl_probe'
   11550 | static int ufshcd_wl_probe(struct scsi_device *sdev)
         |            ^~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11564:13: error: invalid storage class for function 'ufshcd_wl_remove'
   11564 | static void ufshcd_wl_remove(struct scsi_device *sdev)
         |             ^~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11573:20: error: initializer element is not constant
   11573 |         .suspend = ufshcd_wl_suspend,
         |                    ^~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11573:20: note: (near initialization for 'ufshcd_wl_pm_ops.suspend')
   drivers/ufs/core/ufshcd.c:11574:19: error: initializer element is not constant
   11574 |         .resume = ufshcd_wl_resume,
         |                   ^~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11574:19: note: (near initialization for 'ufshcd_wl_pm_ops.resume')
   drivers/ufs/core/ufshcd.c:11575:19: error: initializer element is not constant
   11575 |         .freeze = ufshcd_wl_suspend,
         |                   ^~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11575:19: note: (near initialization for 'ufshcd_wl_pm_ops.freeze')
   drivers/ufs/core/ufshcd.c:11576:17: error: initializer element is not constant
   11576 |         .thaw = ufshcd_wl_resume,
         |                 ^~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11576:17: note: (near initialization for 'ufshcd_wl_pm_ops.thaw')
   drivers/ufs/core/ufshcd.c:11577:21: error: initializer element is not constant
   11577 |         .poweroff = ufshcd_wl_poweroff,
         |                     ^~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11577:21: note: (near initialization for 'ufshcd_wl_pm_ops.poweroff')
   drivers/ufs/core/ufshcd.c:11578:20: error: initializer element is not constant
   11578 |         .restore = ufshcd_wl_resume,
         |                    ^~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11578:20: note: (near initialization for 'ufshcd_wl_pm_ops.restore')
   In file included from include/linux/device.h:25,
                    from include/linux/async.h:14:
   drivers/ufs/core/ufshcd.c:11580:28: error: initializer element is not constant
   11580 |         SET_RUNTIME_PM_OPS(ufshcd_wl_runtime_suspend, ufshcd_wl_runtime_resume, NULL)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/pm.h:339:28: note: in definition of macro 'RUNTIME_PM_OPS'
     339 |         .runtime_suspend = suspend_fn, \
         |                            ^~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11580:9: note: in expansion of macro 'SET_RUNTIME_PM_OPS'
   11580 |         SET_RUNTIME_PM_OPS(ufshcd_wl_runtime_suspend, ufshcd_wl_runtime_resume, NULL)
         |         ^~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11580:28: note: (near initialization for 'ufshcd_wl_pm_ops.runtime_suspend')
   11580 |         SET_RUNTIME_PM_OPS(ufshcd_wl_runtime_suspend, ufshcd_wl_runtime_resume, NULL)
         |                            ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/pm.h:339:28: note: in definition of macro 'RUNTIME_PM_OPS'
     339 |         .runtime_suspend = suspend_fn, \
         |                            ^~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11580:9: note: in expansion of macro 'SET_RUNTIME_PM_OPS'
   11580 |         SET_RUNTIME_PM_OPS(ufshcd_wl_runtime_suspend, ufshcd_wl_runtime_resume, NULL)
         |         ^~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11580:55: error: initializer element is not constant
   11580 |         SET_RUNTIME_PM_OPS(ufshcd_wl_runtime_suspend, ufshcd_wl_runtime_resume, NULL)
         |                                                       ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/pm.h:340:27: note: in definition of macro 'RUNTIME_PM_OPS'
     340 |         .runtime_resume = resume_fn, \
         |                           ^~~~~~~~~
   drivers/ufs/core/ufshcd.c:11580:9: note: in expansion of macro 'SET_RUNTIME_PM_OPS'
   11580 |         SET_RUNTIME_PM_OPS(ufshcd_wl_runtime_suspend, ufshcd_wl_runtime_resume, NULL)
         |         ^~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11580:55: note: (near initialization for 'ufshcd_wl_pm_ops.runtime_resume')
   11580 |         SET_RUNTIME_PM_OPS(ufshcd_wl_runtime_suspend, ufshcd_wl_runtime_resume, NULL)
         |                                                       ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/pm.h:340:27: note: in definition of macro 'RUNTIME_PM_OPS'
     340 |         .runtime_resume = resume_fn, \
         |                           ^~~~~~~~~
   drivers/ufs/core/ufshcd.c:11580:9: note: in expansion of macro 'SET_RUNTIME_PM_OPS'
   11580 |         SET_RUNTIME_PM_OPS(ufshcd_wl_runtime_suspend, ufshcd_wl_runtime_resume, NULL)
         |         ^~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11583:13: error: invalid storage class for function 'ufshcd_check_header_layout'
   11583 | static void ufshcd_check_header_layout(void)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11641:18: error: initializer element is not constant
   11641 |         .probe = ufshcd_wl_probe,
         |                  ^~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11641:18: note: (near initialization for 'ufs_dev_wlun_template.probe')
   drivers/ufs/core/ufshcd.c:11642:19: error: initializer element is not constant
   11642 |         .remove = ufshcd_wl_remove,
         |                   ^~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11642:19: note: (near initialization for 'ufs_dev_wlun_template.remove')
   drivers/ufs/core/ufshcd.c:11643:21: error: initializer element is not constant
   11643 |         .shutdown = ufshcd_wl_shutdown,
         |                     ^~~~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11643:21: note: (near initialization for 'ufs_dev_wlun_template.shutdown')
   drivers/ufs/core/ufshcd.c:11650:19: error: invalid storage class for function 'ufshcd_core_init'
   11650 | static int __init ufshcd_core_init(void)
         |                   ^~~~~~~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11664:20: error: invalid storage class for function 'ufshcd_core_exit'
   11664 | static void __exit ufshcd_core_exit(void)
         |                    ^~~~~~~~~~~~~~~~
   In file included from include/linux/device/driver.h:21,
                    from include/linux/device.h:32:
   include/linux/module.h:132:49: error: invalid storage class for function '__inittest'
     132 |         static inline initcall_t __maybe_unused __inittest(void)                \
         |                                                 ^~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11670:1: note: in expansion of macro 'module_init'
   11670 | module_init(ufshcd_core_init);
         | ^~~~~~~~~~~
   drivers/ufs/core/ufshcd.c:11670:1: warning: 'alias' attribute ignored [-Wattributes]


vim +/ufshcd_vreg_set_hpm +10302 drivers/ufs/core/ufshcd.c

57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10300  
9bb25e5d9d2948 drivers/scsi/ufs/ufshcd.c Bart Van Assche  2021-07-21  10301  #ifdef CONFIG_PM
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25 @10302  static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10303  {
6ab94d0194ddca drivers/ufs/core/ufshcd.c Ed Tsai          2026-03-10  10304  	bool vcc_on = false;
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10305  	int ret = 0;
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10306  
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10307  	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba) &&
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10308  	    !hba->dev_info.is_lu_power_on_wp) {
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10309  		ret = ufshcd_setup_vreg(hba, true);
6ab94d0194ddca drivers/ufs/core/ufshcd.c Ed Tsai          2026-03-10  10310  		vcc_on = true;
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10311  	} else if (!ufshcd_is_ufs_dev_active(hba)) {
23043dd87b153d drivers/scsi/ufs/ufshcd.c Can Guo          2021-04-25  10312  		if (!ufshcd_is_link_active(hba)) {
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10313  			ret = ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq);
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10314  			if (ret)
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10315  				goto vcc_disable;
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10316  			ret = ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq2);
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10317  			if (ret)
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10318  				goto vccq_lpm;
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10319  		}
69d72ac8369a50 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2016-10-27  10320  		ret = ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, true);
6ab94d0194ddca drivers/ufs/core/ufshcd.c Ed Tsai          2026-03-10  10321  		vcc_on = true;
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10322  	}
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10323  	goto out;
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10324  
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10325  vccq_lpm:
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10326  	ufshcd_config_vreg_lpm(hba, hba->vreg_info.vccq);
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10327  vcc_disable:
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10328  	ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, false);
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10329  out:
6ab94d0194ddca drivers/ufs/core/ufshcd.c Ed Tsai          2026-03-10  10330  	/*
6ab94d0194ddca drivers/ufs/core/ufshcd.c Ed Tsai          2026-03-10  10331  	 * On platforms with a slow VCC ramp-up, a delay is needed after
6ab94d0194ddca drivers/ufs/core/ufshcd.c Ed Tsai          2026-03-10  10332  	 * turning on VCC to ensure the voltage is stable before the
6ab94d0194ddca drivers/ufs/core/ufshcd.c Ed Tsai          2026-03-10  10333  	 * reference clock is enabled.
6ab94d0194ddca drivers/ufs/core/ufshcd.c Ed Tsai          2026-03-10  10334  	 */
6ab94d0194ddca drivers/ufs/core/ufshcd.c Ed Tsai          2026-03-10  10335  	if (hba->quirks & UFSHCD_QUIRK_VCC_ON_DELAY && !ret && vcc_on &&
6ab94d0194ddca drivers/ufs/core/ufshcd.c Ed Tsai          2026-03-10  10336  	    hba->vreg_info.vcc && !hba->vreg_info.vcc->always_on)
6ab94d0194ddca drivers/ufs/core/ufshcd.c Ed Tsai          2026-03-10  10337  		usleep_range(1000, 1100);
6ab94d0194ddca drivers/ufs/core/ufshcd.c Ed Tsai          2026-03-10  10338  
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10339  	return ret;
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10340  }
9bb25e5d9d2948 drivers/scsi/ufs/ufshcd.c Bart Van Assche  2021-07-21  10341  #endif /* CONFIG_PM */
57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani 2014-09-25  10342  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
