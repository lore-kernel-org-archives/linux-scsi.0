From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 01/43] qla2xxx: Fix stale memory access for name pointer
Date: Thu, 21 Dec 2017 13:26:59 +0800
Message-ID: <201712211335.XaL3TncM%fengguang.wu@intel.com>
References: <20171220065644.21511-2-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:64079 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750871AbdLUF1i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 00:27:38 -0500
Content-Disposition: inline
In-Reply-To: <20171220065644.21511-2-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Quinn,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on scsi/for-next]
[also build test WARNING on next-20171220]
[cannot apply to v4.15-rc4]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Himanshu-Madhani/qla2xxx-Driver-update/20171221-085840
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)


Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
