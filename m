From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 16/25] scsi: hisi_sas: add dev_found and port_formed
Date: Tue, 13 Oct 2015 06:35:11 +0800
Message-ID: <201510130610.OHuS0tt3%fengguang.wu@intel.com>
References: <1444663237-238302-17-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48987 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbbJLWg2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 18:36:28 -0400
Content-Disposition: inline
In-Reply-To: <1444663237-238302-17-git-send-email-john.garry@huawei.com>
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

   drivers/scsi/hisi_sas/hisi_sas_main.c:321:6: sparse: symbol 'hisi_sas_bytes_dmaed' was not declared. Should it be static?
>> drivers/scsi/hisi_sas/hisi_sas_main.c:358:24: sparse: symbol 'hisi_sas_alloc_dev' was not declared. Should it be static?
>> drivers/scsi/hisi_sas/hisi_sas_main.c:376:5: sparse: symbol 'hisi_sas_dev_found_notify' was not declared. Should it be static?
>> drivers/scsi/hisi_sas/hisi_sas_main.c:479:6: sparse: symbol 'hisi_sas_port_notify_formed' was not declared. Should it be static?
>> drivers/scsi/hisi_sas/hisi_sas_main.c:428:9: sparse: context imbalance in 'hisi_sas_dev_found_notify' - different lock contexts for basic block
>> drivers/scsi/hisi_sas/hisi_sas_main.c:479:6: sparse: context imbalance in 'hisi_sas_port_notify_formed' - different lock contexts for basic block
--
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26:    expected unsigned long long [unsigned] [usertype] val
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26:    got restricted __le64 [usertype] sas_addr
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:24: sparse: incorrect type in assignment (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:24:    expected restricted __le64 [usertype] sas_addr
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:24:    got unsigned long long
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:733:6: sparse: symbol 'enable_phy_v1_hw' was not declared. Should it be static?
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1014:36: sparse: cast from restricted __le32
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1014:36: sparse: incorrect type in initializer (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1014:36:    expected unsigned int [unsigned] [usertype] dma_err_type
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1014:36:    got restricted __le32 [usertype] <noident>
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1022:33: sparse: cast from restricted __le32
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1022:33: sparse: incorrect type in initializer (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1022:33:    expected unsigned int [unsigned] [usertype] trans_tx_fail_type
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1022:33:    got restricted __le32 [usertype] <noident>
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1024:33: sparse: cast from restricted __le32
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1024:33: sparse: incorrect type in initializer (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1024:33:    expected unsigned int [unsigned] [usertype] trans_rx_fail_type
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1024:33:    got restricted __le32 [usertype] <noident>
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1120:5: sparse: symbol 'slot_complete_v1_hw' was not declared. Should it be static?
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1374:34: sparse: cast from restricted __le32
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1374:32: sparse: incorrect type in assignment (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1374:32:    expected unsigned int [unsigned] [usertype] cmplt_hdr_data
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1374:32:    got restricted __le32 [usertype] <noident>

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
