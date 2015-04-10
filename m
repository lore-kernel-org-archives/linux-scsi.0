From: kbuild test robot <fengguang.wu@intel.com>
Subject: [scsi:misc 24/67] drivers/scsi/aacraid/src.c:49:13: sparse: symbol
 'aac_src_intr_message' was not declared. Should it be static?
Date: Fri, 10 Apr 2015 16:53:38 +0800
Message-ID: <201504101622.qu6odppW%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Cc: kbuild-all@01.org, James Bottomley <JBottomley@Odin.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
head:   eef77801b56b098cd7e1daf8a03854dd203a051c
commit: 495c021767bd78c998a46cf8cdd7a4ebf3a9cfd1 [24/67] aacraid: MSI-x support
reproduce:
  # apt-get install sparse
  git checkout 495c021767bd78c998a46cf8cdd7a4ebf3a9cfd1
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/scsi/aacraid/src.c:49:13: sparse: symbol 'aac_src_intr_message' was not declared. Should it be static?
>> drivers/scsi/aacraid/src.c:452:55: sparse: restricted __le16 degrades to integer
   drivers/scsi/aacraid/src.c:487:57: sparse: incorrect type in assignment (different base types)
   drivers/scsi/aacraid/src.c:487:57:    expected restricted __le32 [usertype] SenderFibAddress
   drivers/scsi/aacraid/src.c:487:57:    got unsigned int [unsigned] [usertype] <noident>
   drivers/scsi/aacraid/src.c:499:31: sparse: incorrect type in assignment (different base types)
   drivers/scsi/aacraid/src.c:499:31:    expected unsigned int [unsigned] [usertype] Handle
   drivers/scsi/aacraid/src.c:499:31:    got restricted __le32 [usertype] <noident>
   drivers/scsi/aacraid/src.c:500:36: sparse: incorrect type in assignment (different base types)
   drivers/scsi/aacraid/src.c:500:36:    expected unsigned long long [unsigned] [usertype] HostAddress
   drivers/scsi/aacraid/src.c:500:36:    got restricted __le64 [usertype] <noident>
   drivers/scsi/aacraid/src.c:501:29: sparse: incorrect type in assignment (different base types)
   drivers/scsi/aacraid/src.c:501:29:    expected unsigned int [unsigned] [usertype] Size
   drivers/scsi/aacraid/src.c:501:29:    got restricted __le32 [usertype] <noident>
   drivers/scsi/aacraid/src.c:611:5: sparse: symbol 'aac_src_select_comm' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
