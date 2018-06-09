From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH V2 3/3] scsi: ufs: Add sysfs support for ufs provision
Date: Sat, 9 Jun 2018 19:50:42 +0800
Message-ID: <201806091753.98roOzz9%fengguang.wu@intel.com>
References: <1528455990-24572-4-git-send-email-sayalil@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1528455990-24572-4-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: kbuild-all@01.org, subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, linux-scsi@vger.kernel.org, Sayali Lokhande <sayalil@codeaurora.org>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Adrian Hunter <adrian.hunter@intel.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Sayali,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on robh/for-next]
[also build test WARNING on v4.17 next-20180608]
[cannot apply to mkp-scsi/for-next scsi/for-next]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Sayali-Lokhande/Add-ufs-provisioning-support-in-driver/20180609-151315
base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git for-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/scsi/ufs/ufs-sysfs.c:267:1: sparse: symbol 'dev_attr_ufs_provision' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
