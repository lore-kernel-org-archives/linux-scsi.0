Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C992EE3F36
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 20:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbjIKUvq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 16:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbjIKNpT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 09:45:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52D8CDD
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 06:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694439914; x=1725975914;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=z5GTYzKGUI20qrG4A/t+Tg9f89LdSbzOoWp41PuodF0=;
  b=Q5r6n5QNtINbcngJ6CqjkN9E529ls1kEopD63ivcB6jRSqDOCPCz1fMw
   oEAb9pmjr0KYMDengoUcAN28EFjNEApiXqwodG6DanPB5NqwWYVHAQ8U9
   xFwG/y4JYM0/hChVbPMTzvIyJXtmujh5hS3pmrRqHKtKUdwWGpRXuxUAb
   qzt33iPFs+T1uwBb23SYLQJsIvxXjBmbmT1hMlrm0crLar5lvZ2E81ObK
   qatB0WmywzPhbMBGCGBX7W2QNvV9+XWaQ4skUmJAnae1MrG2CjpKGJEaU
   fSat6yP7TLGkhAe0vqeTVqb0Egnf6mBhEhAkREXgkAjmj1ccvsNKmUoph
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="376998458"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="376998458"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 06:45:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="808829744"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="808829744"
Received: from lkp-server01.sh.intel.com (HELO 59b3c6e06877) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 11 Sep 2023 06:45:12 -0700
Received: from kbuild by 59b3c6e06877 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qfhDy-0006HY-2T;
        Mon, 11 Sep 2023 13:45:10 +0000
Date:   Mon, 11 Sep 2023 21:44:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, Jack Wang <jinpu.wang@ionos.com>
Subject: Re: [PATCH 10/10] scsi: pm8001: Remove PM8001_READ_VPD
Message-ID: <202309112107.YfM4eB8f-lkp@intel.com>
References: <20230911030207.242917-11-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911030207.242917-11-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Damien,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.6-rc1 next-20230911]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Damien-Le-Moal/scsi-pm8001-Setup-IRQs-on-resume/20230911-110427
base:   linus/master
patch link:    https://lore.kernel.org/r/20230911030207.242917-11-dlemoal%40kernel.org
patch subject: [PATCH 10/10] scsi: pm8001: Remove PM8001_READ_VPD
config: i386-randconfig-063-20230911 (https://download.01.org/0day-ci/archive/20230911/202309112107.YfM4eB8f-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230911/202309112107.YfM4eB8f-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309112107.YfM4eB8f-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/scsi/pm8001/pm8001_init.c:696:56: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned long long [usertype] dev_sas_addr @@     got restricted __be64 [usertype] @@
   drivers/scsi/pm8001/pm8001_init.c:696:56: sparse:     expected unsigned long long [usertype] dev_sas_addr
   drivers/scsi/pm8001/pm8001_init.c:696:56: sparse:     got restricted __be64 [usertype]

vim +696 drivers/scsi/pm8001/pm8001_init.c

   680	
   681	/**
   682	 * pm8001_init_sas_add - initialize sas address
   683	 * @pm8001_ha: our ha struct.
   684	 *
   685	 * Currently we just set the fixed SAS address to our HBA, for manufacture,
   686	 * it should read from the EEPROM
   687	 */
   688	static int pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
   689	{
   690		u8 i, j;
   691		u8 sas_add[8];
   692	
   693		if (!pm8001_read_wwn) {
   694			for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
   695				pm8001_ha->phy[i].dev_sas_addr = 0x50010c600047f9d0ULL;
 > 696				pm8001_ha->phy[i].dev_sas_addr =
   697					cpu_to_be64((u64)
   698						(*(u64 *)&pm8001_ha->phy[i].dev_sas_addr));
   699			}
   700			memcpy(pm8001_ha->sas_addr, &pm8001_ha->phy[0].dev_sas_addr,
   701			       SAS_ADDR_SIZE);
   702			return 0;
   703		}
   704	
   705		/*
   706		 * For new SPC controllers WWN is stored in flash vpd. For SPC/SPCve
   707		 * controllers WWN is stored in EEPROM. And for Older SPC WWN is stored
   708		 * in NVMD.
   709		 */
   710		DECLARE_COMPLETION_ONSTACK(completion);
   711		struct pm8001_ioctl_payload payload;
   712		u16 deviceid;
   713		int rc;
   714		unsigned long time_remaining;
   715	
   716		if (PM8001_CHIP_DISP->fatal_errors(pm8001_ha)) {
   717			pm8001_dbg(pm8001_ha, FAIL, "controller is in fatal error state\n");
   718			return -EIO;
   719		}
   720	
   721		pci_read_config_word(pm8001_ha->pdev, PCI_DEVICE_ID, &deviceid);
   722		pm8001_ha->nvmd_completion = &completion;
   723	
   724		if (pm8001_ha->chip_id == chip_8001) {
   725			if (deviceid == 0x8081 || deviceid == 0x0042) {
   726				payload.minor_function = 4;
   727				payload.rd_length = 4096;
   728			} else {
   729				payload.minor_function = 0;
   730				payload.rd_length = 128;
   731			}
   732		} else if ((pm8001_ha->chip_id == chip_8070 ||
   733				pm8001_ha->chip_id == chip_8072) &&
   734				pm8001_ha->pdev->subsystem_vendor == PCI_VENDOR_ID_ATTO) {
   735			payload.minor_function = 4;
   736			payload.rd_length = 4096;
   737		} else {
   738			payload.minor_function = 1;
   739			payload.rd_length = 4096;
   740		}
   741		payload.offset = 0;
   742		payload.func_specific = kzalloc(payload.rd_length, GFP_KERNEL);
   743		if (!payload.func_specific) {
   744			pm8001_dbg(pm8001_ha, FAIL, "mem alloc fail\n");
   745			return -ENOMEM;
   746		}
   747		rc = PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
   748		if (rc) {
   749			kfree(payload.func_specific);
   750			pm8001_dbg(pm8001_ha, FAIL, "nvmd failed\n");
   751			return -EIO;
   752		}
   753		time_remaining = wait_for_completion_timeout(&completion,
   754					msecs_to_jiffies(60*1000)); // 1 min
   755		if (!time_remaining) {
   756			kfree(payload.func_specific);
   757			pm8001_dbg(pm8001_ha, FAIL, "get_nvmd_req timeout\n");
   758			return -EIO;
   759		}
   760	
   761	
   762		for (i = 0, j = 0; i <= 7; i++, j++) {
   763			if (pm8001_ha->chip_id == chip_8001) {
   764				if (deviceid == 0x8081)
   765					pm8001_ha->sas_addr[j] =
   766						payload.func_specific[0x704 + i];
   767				else if (deviceid == 0x0042)
   768					pm8001_ha->sas_addr[j] =
   769						payload.func_specific[0x010 + i];
   770			} else if ((pm8001_ha->chip_id == chip_8070 ||
   771					pm8001_ha->chip_id == chip_8072) &&
   772					pm8001_ha->pdev->subsystem_vendor == PCI_VENDOR_ID_ATTO) {
   773				pm8001_ha->sas_addr[j] =
   774						payload.func_specific[0x010 + i];
   775			} else
   776				pm8001_ha->sas_addr[j] =
   777						payload.func_specific[0x804 + i];
   778		}
   779		memcpy(sas_add, pm8001_ha->sas_addr, SAS_ADDR_SIZE);
   780		for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
   781			if (i && ((i % 4) == 0))
   782				sas_add[7] = sas_add[7] + 4;
   783			memcpy(&pm8001_ha->phy[i].dev_sas_addr,
   784				sas_add, SAS_ADDR_SIZE);
   785			pm8001_dbg(pm8001_ha, INIT, "phy %d sas_addr = %016llx\n", i,
   786				   pm8001_ha->phy[i].dev_sas_addr);
   787		}
   788		kfree(payload.func_specific);
   789	
   790		return 0;
   791	}
   792	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
