From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 05/20] qla2xxx: Added interface to send ELS commands from
 driver.
Date: Tue, 8 Dec 2015 10:10:42 +0800
Message-ID: <201512081044.PEibFacT%fengguang.wu@intel.com>
References: <1449535747-2850-6-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449535747-2850-6-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
Cc: kbuild-all@01.org, target-devel@vger.kernel.org, nab@linux-iscsi.org, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com
List-Id: linux-scsi@vger.kernel.org

Hi Himanshu,

[auto build test WARNING on target/master]
[also build test WARNING on v4.4-rc4 next-20151207]
[cannot apply to scsi/for-next]

url:    https://github.com/0day-ci/linux/commits/Himanshu-Madhani/qla2xxx-Patches-for-target-pending-branch/20151208-093328
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master


coccinelle warnings: (new ones prefixed by >>)

>> drivers/scsi/qla2xxx/qla_iocb.c:2022:2-7: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
