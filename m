From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 07/15] megaraid_sas: Reply Descriptor Post Queue(RDPQ)
 support
Date: Fri, 18 Dec 2015 22:49:20 +0800
Message-ID: <201512182259.Q7txZEEP%fengguang.wu@intel.com>
References: <1450445228-26571-8-git-send-email-Sumit.Saxena@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14040 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbbLROvF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 09:51:05 -0500
Content-Disposition: inline
In-Reply-To: <1450445228-26571-8-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

Hi Sumit,

[auto build test WARNING on scsi/for-next]
[also build test WARNING on v4.4-rc5 next-20151218]

url:    https://github.com/0day-ci/linux/commits/Sumit-Saxena/megaraid_sas-Do-not-allow-PCI-access-during-OCR/20151218-213231
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next


coccinelle warnings: (new ones prefixed by >>)

>> drivers/scsi/megaraid/megaraid_sas_fusion.c:331:20-27: WARNING: kzalloc should be used for fusion -> cmd_list, instead of kmalloc/memset
>> drivers/scsi/megaraid/megaraid_sas_fusion.c:342:24-31: WARNING: kzalloc should be used for fusion -> cmd_list [ i ], instead of kmalloc/memset

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
