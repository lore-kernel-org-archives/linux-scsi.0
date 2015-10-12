From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 18/25] scsi: hisi_sas: add dev_gone and port_deformed
Date: Tue, 13 Oct 2015 06:49:58 +0800
Message-ID: <201510130647.HK3md76n%fengguang.wu@intel.com>
References: <1444663237-238302-19-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444663237-238302-19-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-kernel-u79uwXL29TZ19SzzRMN9sA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi John,

[auto build test WARNING on scsi/for-next -- if it's inappropriate base, please suggest rules for selecting the more suitable base]

url:    https://github.com/0day-ci/linux/commits/John-Garry/HiSilicon-SAS-driver/20151012-231929
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/scsi/hisi_sas/hisi_sas_main.c:321:6: sparse: symbol 'hisi_sas_bytes_dmaed' was not declared. Should it be static?
   drivers/scsi/hisi_sas/hisi_sas_main.c:358:24: sparse: symbol 'hisi_sas_alloc_dev' was not declared. Should it be static?
   drivers/scsi/hisi_sas/hisi_sas_main.c:376:5: sparse: symbol 'hisi_sas_dev_found_notify' was not declared. Should it be static?
   drivers/scsi/hisi_sas/hisi_sas_main.c:479:6: sparse: symbol 'hisi_sas_port_notify_formed' was not declared. Should it be static?
>> drivers/scsi/hisi_sas/hisi_sas_main.c:517:6: sparse: symbol 'hisi_sas_do_release_task' was not declared. Should it be static?
   drivers/scsi/hisi_sas/hisi_sas_main.c:428:9: sparse: context imbalance in 'hisi_sas_dev_found_notify' - different lock contexts for basic block
   drivers/scsi/hisi_sas/hisi_sas_main.c:479:6: sparse: context imbalance in 'hisi_sas_port_notify_formed' - different lock contexts for basic block
--
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26:    expected unsigned long long [unsigned] [usertype] val
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26:    got restricted __le64 [usertype] sas_addr
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:26: sparse: cast from restricted __le64
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:24: sparse: incorrect type in assignment (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:24:    expected restricted __le64 [usertype] sas_addr
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:528:24:    got unsigned long long
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:553:15: sparse: cast from restricted __le64
>> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:553:13: sparse: incorrect type in assignment (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:553:13:    expected unsigned int [unsigned] [usertype] qw0
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:553:13:    got restricted __le64 [usertype] <noident>
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:761:6: sparse: symbol 'enable_phy_v1_hw' was not declared. Should it be static?
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1042:36: sparse: cast from restricted __le32
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1042:36: sparse: incorrect type in initializer (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1042:36:    expected unsigned int [unsigned] [usertype] dma_err_type
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1042:36:    got restricted __le32 [usertype] <noident>
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1050:33: sparse: cast from restricted __le32
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1050:33: sparse: incorrect type in initializer (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1050:33:    expected unsigned int [unsigned] [usertype] trans_tx_fail_type
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1050:33:    got restricted __le32 [usertype] <noident>
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1052:33: sparse: cast from restricted __le32
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1052:33: sparse: incorrect type in initializer (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1052:33:    expected unsigned int [unsigned] [usertype] trans_rx_fail_type
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1052:33:    got restricted __le32 [usertype] <noident>
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1456:34: sparse: cast from restricted __le32
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1456:32: sparse: incorrect type in assignment (different base types)
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1456:32:    expected unsigned int [unsigned] [usertype] cmplt_hdr_data
   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1456:32:    got restricted __le32 [usertype] <noident>

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
