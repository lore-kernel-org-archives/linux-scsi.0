From: kbuild test robot <fengguang.wu@intel.com>
Subject: [net-next:master 62/63] drivers/scsi/csiostor/csio_hw.c:2012:5:
 sparse: symbol 'csio_hw_prep_fw' was not declared. Should it be static?
Date: Fri, 9 Jan 2015 12:52:13 +0800
Message-ID: <201501091252.dqPVA7db%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Praveen Madhavan <praveenm@chelsio.com>
Cc: kbuild-all@01.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hariprasad Shenai <hariprasad@chelsio.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   fb57720daf6e56ba453414b5e8dd9cb3c0c80257
commit: f40e74ffa3de44f7ef4c09653b070dd115ab7fbe [62/63] csiostor:firmware upgrade fix
reproduce:
  # apt-get install sparse
  git checkout f40e74ffa3de44f7ef4c09653b070dd115ab7fbe
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/scsi/csiostor/csio_hw.c:259:17: sparse: cast to restricted __le32
   drivers/scsi/csiostor/csio_hw.c:536:31: sparse: incorrect type in assignment (different base types)
   drivers/scsi/csiostor/csio_hw.c:536:31:    expected unsigned int [unsigned] [usertype] <noident>
   drivers/scsi/csiostor/csio_hw.c:536:31:    got restricted __be32 [usertype] <noident>
>> drivers/scsi/csiostor/csio_hw.c:2012:5: sparse: symbol 'csio_hw_prep_fw' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
