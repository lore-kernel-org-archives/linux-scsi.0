From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCHv5 2/5] scsi: Export blacklist flags to sysfs
Date: Sun, 24 Sep 2017 07:22:48 +0800
Message-ID: <201709240727.2xFHlSF8%fengguang.wu@intel.com>
References: <1506060287-87031-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7230 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750839AbdIWXXP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 23 Sep 2017 19:23:15 -0400
Content-Disposition: inline
In-Reply-To: <1506060287-87031-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Hi Hannes,

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on v4.14-rc1 next-20170922]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Hannes-Reinecke/scsi-Fixup-blacklist-handling/20170923-213041
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
