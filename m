From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 1/2] Convert target drivers to use sbitmap
Date: Wed, 16 May 2018 20:47:21 +0800
Message-ID: <201805162035.EWoS94Oq%fengguang.wu@intel.com>
References: <20180515160043.27044-2-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180515160043.27044-2-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-usb@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, Juergen Gross <jgross@suse.com>, qla2xxx-upstream@qlogic.com, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <mawilcox@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Hi Matthew,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.17-rc5 next-20180516]
[cannot apply to target/master]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Matthew-Wilcox/Use-sbitmap-instead-of-percpu_ida/20180516-143658
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/target/iscsi/iscsi_target_util.c:150:5: sparse: symbol 'iscsit_wait_for_tag' was not declared. Should it be static?
   drivers/target/iscsi/iscsi_target_util.c:1174:31: sparse: expression using sizeof(void)
   drivers/target/iscsi/iscsi_target_util.c:1174:31: sparse: expression using sizeof(void)

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
