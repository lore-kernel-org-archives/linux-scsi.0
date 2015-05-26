From: kbuild test robot <fengguang.wu@intel.com>
Subject: [target:for-next 53/60] drivers/target/target_core_device.c:652:6:
 sparse: symbol 'se_dev_check_wce' was not declared. Should it be static?
Date: Tue, 26 May 2015 16:13:20 +0800
Message-ID: <201505261605.Y1XY0zLc%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:6407 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbbEZINk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 May 2015 04:13:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: kbuild-all@01.org, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next
head:   9cfc3ea41c4f9db514a7fdde9b77657b5aeaa46c
commit: 9c10e8080d9ac17ec5b0b9f7da1a5dd31215ef5e [53/60] target: simplify backend attribute implementation
reproduce:
  # apt-get install sparse
  git checkout 9c10e8080d9ac17ec5b0b9f7da1a5dd31215ef5e
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/target/target_core_device.c:249:38: sparse: incorrect type in initializer (different address spaces)
   drivers/target/target_core_device.c:249:38:    expected struct se_lun *lun
   drivers/target/target_core_device.c:249:38:    got struct se_lun [noderef] <asn:4>*_________p1
   drivers/target/target_core_device.c:339:43: sparse: incorrect type in initializer (different address spaces)
   drivers/target/target_core_device.c:339:43:    expected struct se_lun *orig_lun
   drivers/target/target_core_device.c:339:43:    got struct se_lun [noderef] <asn:4>*_________p1
   drivers/target/target_core_device.c:445:50: sparse: incorrect type in initializer (different address spaces)
   drivers/target/target_core_device.c:445:50:    expected struct se_lun *tmp_lun
   drivers/target/target_core_device.c:445:50:    got struct se_lun [noderef] <asn:4>*_________p1
>> drivers/target/target_core_device.c:652:6: sparse: symbol 'se_dev_check_wce' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
