Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5D3FC0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 17:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjG0RHs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 13:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjG0RHq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 13:07:46 -0400
Received: from mgamail.intel.com (unknown [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41FA2726
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 10:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690477665; x=1722013665;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=II4/iGw5o80kuCEwddcvTkX+C4IdTACHdyV4yZwK5oM=;
  b=cJlUYWGs1ScFLTwRx/P1dFSlhuNcdp20j3Z5FTdPmiQqD/GbabW/RurF
   0rQccqSrNasJVLktI9ySBZADsdVCVqvhwjgaZNIWKytDkx8ZpPwXUsrsJ
   prXdK2O8h6xpbrnvugMyN+wBqC6FNSONJKcb4y/xLFwWmFWzD/gz0cftp
   0FNV5fiE63jq1pAA4GT6Xs/iUTYpO+dqQE/CmCoh6WY5xA2AAvLI+mWGJ
   aWoz1Igrjwp5szT36Y8OT/p/dAKZZ6uxpl0fv58EpPptYSNzOl+7/IQvD
   9KftsgTS6JTm295FsCm22n+I3jfFjk32nr2C3t4bLygPTDw3KmuUKtl2I
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10784"; a="358396273"
X-IronPort-AV: E=Sophos;i="6.01,235,1684825200"; 
   d="scan'208";a="358396273"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2023 10:07:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10784"; a="762248098"
X-IronPort-AV: E=Sophos;i="6.01,235,1684825200"; 
   d="scan'208";a="762248098"
Received: from lkp-server02.sh.intel.com (HELO 953e8cd98f7d) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 27 Jul 2023 10:07:32 -0700
Received: from kbuild by 953e8cd98f7d with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qP4SZ-0002Rf-1C;
        Thu, 27 Jul 2023 17:07:31 +0000
Date:   Fri, 28 Jul 2023 01:06:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ranjan Kumar <ranjan.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     oe-kbuild-all@lists.linux.dev, rajsekhar.chundru@broadcom.com,
        sathya.prakash@broadcom.com, sumit.saxena@broadcom.com,
        chandrakanth.patil@broadcom.com, sreekanth.reddy@broadcom.com,
        Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: Re: [PATCH v1 4/6] mpi3mr: WriteSame implementation
Message-ID: <202307280034.DXU5pTVV-lkp@intel.com>
References: <20230724132303.19470-5-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724132303.19470-5-ranjan.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Ranjan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.5-rc3 next-20230727]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ranjan-Kumar/mpi3mr-Invokes-soft-reset-upon-TSU-or-event-ack-time-out/20230724-212757
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20230724132303.19470-5-ranjan.kumar%40broadcom.com
patch subject: [PATCH v1 4/6] mpi3mr: WriteSame implementation
config: x86_64-randconfig-m001-20230726 (https://download.01.org/0day-ci/archive/20230728/202307280034.DXU5pTVV-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce: (https://download.01.org/0day-ci/archive/20230728/202307280034.DXU5pTVV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202307280034.DXU5pTVV-lkp@intel.com/

smatch warnings:
drivers/scsi/mpi3mr/mpi3mr_os.c:4514 mpi3mr_target_alloc() warn: inconsistent indenting

vim +4514 drivers/scsi/mpi3mr/mpi3mr_os.c

  4477	
  4478	/**
  4479	 * mpi3mr_target_alloc - Target alloc callback handler
  4480	 * @starget: SCSI target reference
  4481	 *
  4482	 * Allocate per target private data and initialize it.
  4483	 *
  4484	 * Return: 0 on success -ENOMEM on memory allocation failure.
  4485	 */
  4486	static int mpi3mr_target_alloc(struct scsi_target *starget)
  4487	{
  4488		struct Scsi_Host *shost = dev_to_shost(&starget->dev);
  4489		struct mpi3mr_ioc *mrioc = shost_priv(shost);
  4490		struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
  4491		struct mpi3mr_tgt_dev *tgt_dev;
  4492		unsigned long flags;
  4493		int retval = 0;
  4494		struct sas_rphy *rphy = NULL;
  4495	
  4496		scsi_tgt_priv_data = kzalloc(sizeof(*scsi_tgt_priv_data), GFP_KERNEL);
  4497		if (!scsi_tgt_priv_data)
  4498			return -ENOMEM;
  4499	
  4500		starget->hostdata = scsi_tgt_priv_data;
  4501	
  4502		spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
  4503		if (starget->channel == mrioc->scsi_device_channel) {
  4504			tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
  4505			if (tgt_dev && !tgt_dev->is_hidden) {
  4506				scsi_tgt_priv_data->starget = starget;
  4507				scsi_tgt_priv_data->dev_handle = tgt_dev->dev_handle;
  4508				scsi_tgt_priv_data->perst_id = tgt_dev->perst_id;
  4509				scsi_tgt_priv_data->dev_type = tgt_dev->dev_type;
  4510				scsi_tgt_priv_data->tgt_dev = tgt_dev;
  4511				tgt_dev->starget = starget;
  4512				atomic_set(&scsi_tgt_priv_data->block_io, 0);
  4513				retval = 0;
> 4514			if ((tgt_dev->dev_type == MPI3_DEVICE_DEVFORM_PCIE) &&
  4515			    ((tgt_dev->dev_spec.pcie_inf.dev_info &
  4516			    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) ==
  4517			    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NVME_DEVICE) &&
  4518			    ((tgt_dev->dev_spec.pcie_inf.dev_info &
  4519			    MPI3_DEVICE0_PCIE_DEVICE_INFO_PITYPE_MASK) !=
  4520			    MPI3_DEVICE0_PCIE_DEVICE_INFO_PITYPE_0))
  4521				scsi_tgt_priv_data->dev_nvme_dif = 1;
  4522			scsi_tgt_priv_data->io_throttle_enabled = tgt_dev->io_throttle_enabled;
  4523			scsi_tgt_priv_data->wslen = tgt_dev->wslen;
  4524			if (tgt_dev->dev_type == MPI3_DEVICE_DEVFORM_VD)
  4525				scsi_tgt_priv_data->throttle_group = tgt_dev->dev_spec.vd_inf.tg;
  4526			} else
  4527				retval = -ENXIO;
  4528		} else if (mrioc->sas_transport_enabled && !starget->channel) {
  4529			rphy = dev_to_rphy(starget->dev.parent);
  4530			tgt_dev = __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
  4531			    rphy->identify.sas_address, rphy);
  4532			if (tgt_dev && !tgt_dev->is_hidden && !tgt_dev->non_stl &&
  4533			    (tgt_dev->dev_type == MPI3_DEVICE_DEVFORM_SAS_SATA)) {
  4534				scsi_tgt_priv_data->starget = starget;
  4535				scsi_tgt_priv_data->dev_handle = tgt_dev->dev_handle;
  4536				scsi_tgt_priv_data->perst_id = tgt_dev->perst_id;
  4537				scsi_tgt_priv_data->dev_type = tgt_dev->dev_type;
  4538				scsi_tgt_priv_data->tgt_dev = tgt_dev;
  4539				scsi_tgt_priv_data->io_throttle_enabled = tgt_dev->io_throttle_enabled;
  4540				scsi_tgt_priv_data->wslen = tgt_dev->wslen;
  4541				tgt_dev->starget = starget;
  4542				atomic_set(&scsi_tgt_priv_data->block_io, 0);
  4543				retval = 0;
  4544			} else
  4545				retval = -ENXIO;
  4546		}
  4547		spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
  4548	
  4549		return retval;
  4550	}
  4551	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
