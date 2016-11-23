From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] [hv] storvsc: Payload buffer incorrectly sized for 32
 bit kernels.
Date: Wed, 23 Nov 2016 10:56:24 +0800
Message-ID: <201611231035.GigM5iAx%fengguang.wu@intel.com>
References: <1479836185-6741-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1479836185-6741-1-git-send-email-cavery@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Cathy Avery <cavery@redhat.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, haiyangz@microsoft.com, linux-kernel@vger.kernel.org, kbuild-all@01.org, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

Hi Cathy,

[auto build test WARNING on scsi/for-next]
[also build test WARNING on v4.9-rc6 next-20161122]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Cathy-Avery/storvsc-Payload-buffer-incorrectly-sized-for-32-bit-kernels/20161123-091420
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next


coccinelle warnings: (new ones prefixed by >>)

>> drivers/scsi/storvsc_drv.c:1500:13-20: WARNING: kzalloc should be used for payload, instead of kmalloc/memset

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
