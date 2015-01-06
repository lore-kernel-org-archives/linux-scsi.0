From: kbuild test robot <fengguang.wu@intel.com>
Subject: [target:nvme_of 3/3]
 drivers/target/nvme_of/nvme_of_configfs.c:25:31: sparse: symbol
 'nvme_of_fabric_configfs' was not declared. Should it be static?
Date: Wed, 7 Jan 2015 03:35:56 +0800
Message-ID: <201501070334.EgwC5iey%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: target-devel-owner@vger.kernel.org
To: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git nvme_of
head:   40d8c11927282d59855d645b35798edd97828da5
commit: 40d8c11927282d59855d645b35798edd97828da5 [3/3] nvme_of: Initial skeleton commit
reproduce:
  # apt-get install sparse
  git checkout 40d8c11927282d59855d645b35798edd97828da5
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/target/nvme_of/nvme_of_configfs.c:25:31: sparse: symbol 'nvme_of_fabric_configfs' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
