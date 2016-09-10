From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 3/5] hpsa: check for vpd support before sending
Date: Sat, 10 Sep 2016 11:05:47 +0800
Message-ID: <201609101123.03n9exm4%fengguang.wu@intel.com>
References: <147345662985.19269.15459802044850867924.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:4185 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752626AbcIJDGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Sep 2016 23:06:32 -0400
Content-Disposition: inline
In-Reply-To: <147345662985.19269.15459802044850867924.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: kbuild-all@01.org, jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

Hi Scott,

[auto build test WARNING on scsi/for-next]
[also build test WARNING on v4.8-rc5 next-20160909]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
[Suggest to use git(>=2.9.0) format-patch --base=<commit> (or --base=auto for convenience) to record what (public, well-known) commit your patch series was built on]
[Check https://git-scm.com/docs/git-format-patch for more information]

url:    https://github.com/0day-ci/linux/commits/Don-Brace/hpsa-determine-device-external-status-earlier/20160910-054751
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next


coccinelle warnings: (new ones prefixed by >>)

>> drivers/scsi/hpsa.c:3473:9-10: WARNING: return of 0/1 in function 'hpsa_vpd_page_supported' with return type bool

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
