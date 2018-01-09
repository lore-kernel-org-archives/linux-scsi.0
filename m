From: kbuild test robot <fengguang.wu@intel.com>
Subject: [mkp-scsi:for-next 237/263]
 drivers/scsi/libsas/sas_discover.c:364:6: sparse: symbol
 'sas_destruct_ports' was not declared. Should it be static?
Date: Tue, 9 Jan 2018 15:51:58 +0800
Message-ID: <201801091521.r3DztdJM%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61412 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751978AbeAIHwX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 9 Jan 2018 02:52:23 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>
Cc: kbuild-all@01.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Yijing Wang <wangyijing@huawei.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
head:   f7c3d0667404295422c9a5d71fd87ca20c770f49
commit: 99cfdc04c12ea1bc5719bff15f24dae8b5b90da9 [237/263] scsi: libsas: direct call probe and destruct
reproduce:
        # apt-get install sparse
        git checkout 99cfdc04c12ea1bc5719bff15f24dae8b5b90da9
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/scsi/libsas/sas_discover.c:364:6: sparse: symbol 'sas_destruct_ports' was not declared. Should it be

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
