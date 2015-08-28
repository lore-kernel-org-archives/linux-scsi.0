From: kbuild test robot <fengguang.wu@intel.com>
Subject: [scsi:misc 95/113] drivers/scsi/mpt3sas/mpt3sas_base.c:1820:1:
 sparse: symbol 'mpt3sas_base_unmap_resources' was not declared. Should it be
 static?
Date: Fri, 28 Aug 2015 09:20:22 +0800
Message-ID: <201508280958.jLBYjhIZ%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63764 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbbH1BVp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 21:21:45 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: kbuild-all@01.org, James Bottomley <JBottomley@Odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
head:   b9e8a16466e62d46c0b8551fb807173d6a9c529f
commit: 580d4e3153f0d7a9a9235b675b0b7b13e2185a8b [95/113] mpt3sas: Remove redundancy code while freeing the controller resources.
reproduce:
  # apt-get install sparse
  git checkout 580d4e3153f0d7a9a9235b675b0b7b13e2185a8b
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/scsi/mpt3sas/mpt3sas_base.c:1031:52: sparse: incorrect type in argument 2 (different address spaces)
   drivers/scsi/mpt3sas/mpt3sas_base.c:1031:52:    expected void volatile [noderef] <asn:2>*addr
   drivers/scsi/mpt3sas/mpt3sas_base.c:1031:52:    got unsigned long long [usertype] *<noident>
>> drivers/scsi/mpt3sas/mpt3sas_base.c:1820:1: sparse: symbol 'mpt3sas_base_unmap_resources' was not declared. Should it be static?
   drivers/scsi/mpt3sas/mpt3sas_base.c:1958:32: sparse: cast removes address space of expression
   drivers/scsi/mpt3sas/mpt3sas_base.c:2204:16: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/mpt3sas/mpt3sas_base.c:2204:16:    expected unsigned long [unsigned] val
   drivers/scsi/mpt3sas/mpt3sas_base.c:2204:16:    got restricted __le64 [usertype] <noident>
   drivers/scsi/mpt3sas/mpt3sas_base.c:2204:16: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/mpt3sas/mpt3sas_base.c:2204:16:    expected unsigned long [unsigned] val
   drivers/scsi/mpt3sas/mpt3sas_base.c:2204:16:    got restricted __le64 [usertype] <noident>
   drivers/scsi/mpt3sas/mpt3sas_base.c:2204:16: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/mpt3sas/mpt3sas_base.c:2204:16:    expected unsigned long [unsigned] val
   drivers/scsi/mpt3sas/mpt3sas_base.c:2204:16:    got restricted __le64 [usertype] <noident>
   drivers/scsi/mpt3sas/mpt3sas_base.c:2204:16: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/mpt3sas/mpt3sas_base.c:2204:16:    expected unsigned long [unsigned] val
   drivers/scsi/mpt3sas/mpt3sas_base.c:2204:16:    got restricted __le64 [usertype] <noident>
   drivers/scsi/mpt3sas/mpt3sas_base.c:3446:24: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/mpt3sas/mpt3sas_base.c:3446:24:    expected unsigned int [unsigned] val
   drivers/scsi/mpt3sas/mpt3sas_base.c:3446:24:    got restricted __le32 [usertype] <noident>
   drivers/scsi/mpt3sas/mpt3sas_base.c:3467:20: sparse: cast to restricted __le16
   drivers/scsi/mpt3sas/mpt3sas_base.c:3476:20: sparse: cast to restricted __le16
   drivers/scsi/mpt3sas/mpt3sas_base.c:3490:36: sparse: cast to restricted __le16
   drivers/scsi/mpt3sas/mpt3sas_base.c:4673:55: sparse: incorrect type in argument 2 (different address spaces)
   drivers/scsi/mpt3sas/mpt3sas_base.c:4673:55:    expected void volatile [noderef] <asn:2>*addr
   drivers/scsi/mpt3sas/mpt3sas_base.c:4673:55:    got unsigned long long [usertype] *<noident>

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
