From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v2 5/5] lib: scatterlist: move SG pool code from SCSI
 driver to lib/sg_pool.c
Date: Wed, 23 Mar 2016 10:38:12 +0800
Message-ID: <201603231036.A8dUuAli%fengguang.wu@intel.com>
References: <1458684196-15923-6-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17655 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbcCWCjX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2016 22:39:23 -0400
Content-Disposition: inline
In-Reply-To: <1458684196-15923-6-git-send-email-mlin@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Hi Ming,

[auto build test WARNING on scsi/for-next]
[also build test WARNING on v4.5 next-20160322]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Ming-Lin/mempool-based-chained-scatterlist-alloc-free-api/20160323-060710
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next


coccinelle warnings: (new ones prefixed by >>)

>> lib/sg_pool.c:152:3-18: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.
   lib/sg_pool.c:154:3-21: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
