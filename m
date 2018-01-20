From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 5/6] mpt3sas: Introduce function to clone mpi request.
Date: Sun, 21 Jan 2018 02:38:49 +0800
Message-ID: <201801210223.UdUzpd8q%fengguang.wu@intel.com>
References: <1516365462-14708-6-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:40919 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756385AbeATSjp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 20 Jan 2018 13:39:45 -0500
Content-Disposition: inline
In-Reply-To: <1516365462-14708-6-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, chaitra.basappa@broadcom.com, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

Hi Suganath,

I love your patch! Perhaps something to improve:

[auto build test WARNING on scsi/for-next]
[also build test WARNING on v4.15-rc8 next-20180119]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Suganath-Prabu-S/mpt3sas-Add-PCI-device-ID-for-Andromeda/20180121-002454
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/scsi/mpt3sas/mpt3sas_base.c:143:24: sparse: cast from restricted __le32
   drivers/scsi/mpt3sas/mpt3sas_base.c:143:24: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:143:24: expected unsigned int val
   drivers/scsi/mpt3sas/mpt3sas_base.c:143:24: got restricted __le32 <noident>
   drivers/scsi/mpt3sas/mpt3sas_base.c:143:64: sparse: incorrect type in argument 2 (different address spaces) @@ expected void volatile @@ got @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:143:64: expected void volatile
   drivers/scsi/mpt3sas/mpt3sas_base.c:143:64: got void COPYING CREDITS Documentation Kbuild Kconfig MAINTAINERS Makefile README arch block certs crypto drivers firmware fs include init ipc kernel lib mm net samples scripts security sound tools usr virt
   drivers/scsi/mpt3sas/mpt3sas_base.c:160:24: sparse: cast from restricted __le32
   drivers/scsi/mpt3sas/mpt3sas_base.c:160:24: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:160:24: expected unsigned int val
   drivers/scsi/mpt3sas/mpt3sas_base.c:160:24: got restricted __le32 <noident>
   drivers/scsi/mpt3sas/mpt3sas_base.c:160:64: sparse: incorrect type in argument 2 (different address spaces) @@ expected void volatile @@ got @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:160:64: expected void volatile
   drivers/scsi/mpt3sas/mpt3sas_base.c:160:64: got void COPYING CREDITS Documentation Kbuild Kconfig MAINTAINERS Makefile README arch block certs crypto drivers firmware fs include init ipc kernel lib mm net samples scripts security sound tools usr virt
   drivers/scsi/mpt3sas/mpt3sas_base.c:180:24: sparse: cast removes address space of expression
   drivers/scsi/mpt3sas/mpt3sas_base.c:333:24: sparse: undefined identifier 'mpt3sas_scsih_scsi_lookup_get'
   drivers/scsi/mpt3sas/mpt3sas_base.c:1182:42: sparse: incorrect type in assignment (different base types) @@ expected unsigned short Event @@ got short Event @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:1183:49: sparse: incorrect type in assignment (different base types) @@ expected unsigned int EventContext @@ got ed int EventContext @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:1401:64: sparse: incorrect type in argument 2 (different address spaces) @@ expected void volatile @@ got oid volatile @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:1450:52: sparse: incorrect type in argument 2 (different address spaces) @@ expected void volatile @@ got oid volatile @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:2982:32: sparse: cast removes address space of expression
   drivers/scsi/mpt3sas/mpt3sas_base.c:3330:26: sparse: cast removes address space of expression
>> drivers/scsi/mpt3sas/mpt3sas_base.c:3274:26: sparse: incorrect type in initializer (different base types) @@ expected unsigned long long data_out @@ got g long data_out @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3297:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3297:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3414:34: sparse: cast removes address space of expression
>> drivers/scsi/mpt3sas/mpt3sas_base.c:3274:26: sparse: incorrect type in initializer (different base types) @@ expected unsigned long long data_out @@ got g long data_out @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3297:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3297:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3483:34: sparse: cast removes address space of expression
>> drivers/scsi/mpt3sas/mpt3sas_base.c:3274:26: sparse: incorrect type in initializer (different base types) @@ expected unsigned long long data_out @@ got g long data_out @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3297:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3523:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3545:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3568:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3589:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3610:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:5062:24: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:5083:20: sparse: cast to restricted __le16
   drivers/scsi/mpt3sas/mpt3sas_base.c:5092:20: sparse: cast to restricted __le16
   drivers/scsi/mpt3sas/mpt3sas_base.c:5106:36: sparse: cast to restricted __le16
   drivers/scsi/mpt3sas/mpt3sas_base.c:6287:55: sparse: incorrect type in argument 2 (different address spaces) @@ expected void volatile @@ got oid volatile @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:333:53: sparse: call with no type!
   drivers/scsi/mpt3sas/mpt3sas_base.c: In function '_clone_sg_entries':
   drivers/scsi/mpt3sas/mpt3sas_base.c:333:10: error: implicit declaration of function 'mpt3sas_scsih_scsi_lookup_get'; did you mean
    scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    mpt3sas_scsih_issue_locked_tm
   drivers/scsi/mpt3sas/mpt3sas_base.c:333:8: warning: assignment makes pointer from integer without a cast
    scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
    ^
   cc1: some warnings being treated as errors

vim +3274 drivers/scsi/mpt3sas/mpt3sas_base.c

  3258	
  3259	/**
  3260	 * _base_mpi_ep_writeq - 32 bit write to MMIO
  3261	 * @b: data payload
  3262	 * @addr: address in MMIO space
  3263	 * @writeq_lock: spin lock
  3264	 *
  3265	 * This special handling for MPI EP to take care of 32 bit
  3266	 * environment where its not quarenteed to send the entire word
  3267	 * in one transfer.
  3268	 */
  3269	static inline void
  3270	_base_mpi_ep_writeq(__u64 b, volatile void __iomem *addr,
  3271						spinlock_t *writeq_lock)
  3272	{
  3273		unsigned long flags;
> 3274		__u64 data_out = cpu_to_le64(b);
  3275	
  3276		spin_lock_irqsave(writeq_lock, flags);
  3277		writel((u32)(data_out), addr);
  3278		writel((u32)(data_out >> 32), (addr + 4));
  3279		spin_unlock_irqrestore(writeq_lock, flags);
  3280	}
  3281	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
