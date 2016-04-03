From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 4/8] char: rpmb: provide user space interface
Date: Sun, 3 Apr 2016 18:36:08 +0800
Message-ID: <201604031822.7UBwspdK%fengguang.wu@intel.com>
References: <1459676572-29921-5-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459676572-29921-5-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: kbuild-all@01.org, gregkh@linuxfoundation.org, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Joao Pinto <Joao.Pinto@synopsys.com>, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hi Tomas,

[auto build test WARNING on char-misc/char-misc-testing]
[also build test WARNING on v4.6-rc1 next-20160401]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Tomas-Winkler/Replay-Protected-Memory-Block-RPMB-subsystem/20160403-174929


coccinelle warnings: (new ones prefixed by >>)

>> drivers/char/rpmb/cdev.c:94:13-20: WARNING opportunity for memdup_user

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
