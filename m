From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 22/25] scsi: hisi_sas: add tmf methods
Date: Tue, 13 Oct 2015 07:02:47 +0800
Message-ID: <201510130626.V3reAw1w%fengguang.wu@intel.com>
References: <1444663237-238302-23-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46474 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbbJLXEL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 19:04:11 -0400
Content-Disposition: inline
In-Reply-To: <1444663237-238302-23-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

Hi John,

[auto build test WARNING on scsi/for-next -- if it's inappropriate base, please suggest rules for selecting the more suitable base]

url:    https://github.com/0day-ci/linux/commits/John-Garry/HiSilicon-SAS-driver/20151012-231929
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/scsi/hisi_sas/hisi_sas_main.c:341:6: sparse: symbol 'hisi_sas_bytes_dmaed' was not declared. Should it be static?
   drivers/scsi/hisi_sas/hisi_sas_main.c:378:24: sparse: symbol 'hisi_sas_alloc_dev' was not declared. Should it be static?
   drivers/scsi/hisi_sas/hisi_sas_main.c:396:5: sparse: symbol 'hisi_sas_dev_found_notify' was not declared. Should it be static?
   drivers/scsi/hisi_sas/hisi_sas_main.c:523:6: sparse: symbol 'hisi_sas_port_notify_formed' was not declared. Should it be static?
   drivers/scsi/hisi_sas/hisi_sas_main.c:561:6: sparse: symbol 'hisi_sas_do_release_task' was not declared. Should it be static?
>> drivers/scsi/hisi_sas/hisi_sas_main.c:615:5: sparse: symbol 'hisi_sas_find_dev_phyno' was not declared. Should it be static?
>> drivers/scsi/hisi_sas/hisi_sas_main.c:852:52: sparse: incorrect type in assignment (different base types)
   drivers/scsi/hisi_sas/hisi_sas_main.c:852:52:    expected unsigned short [unsigned] [assigned] [usertype] tag_of_task_to_be_managed
   drivers/scsi/hisi_sas/hisi_sas_main.c:852:52:    got restricted __le16 [usertype] <noident>
   drivers/scsi/hisi_sas/hisi_sas_main.c:1000:52: sparse: incorrect type in assignment (different base types)
   drivers/scsi/hisi_sas/hisi_sas_main.c:1000:52:    expected unsigned short [unsigned] [assigned] [usertype] tag_of_task_to_be_managed
   drivers/scsi/hisi_sas/hisi_sas_main.c:1000:52:    got restricted __le16 [usertype] <noident>
   drivers/scsi/hisi_sas/hisi_sas_main.c:448:9: sparse: context imbalance in 'hisi_sas_dev_found_notify' - different lock contexts for basic block
   drivers/scsi/hisi_sas/hisi_sas_main.c:523:6: sparse: context imbalance in 'hisi_sas_port_notify_formed' - different lock contexts for basic block

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
