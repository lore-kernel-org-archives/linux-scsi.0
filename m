From: kbuild test robot <fengguang.wu@intel.com>
Subject: [scsi:misc 64/77] drivers/scsi/aacraid/linit.c:1321:6: sparse:
 symbol 'aac_release_resources' was not declared. Should it be static?
Date: Tue, 10 Nov 2015 13:59:06 +0800
Message-ID: <201511101352.WifvAYu2%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:43043 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbbKJGA0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Nov 2015 01:00:26 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, James Bottomley <JBottomley@Odin.com>, Tomas Henzl <thenzl@redhat.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Karthikeya Sunkesula <Karthikeya.Sunkesula@pmcs.com>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
head:   46782becf4cc80153bdefebdb548ad35a5cd8b06
commit: de665f28f788ad72ff6a0ce6ac2721d77248b7cf [64/77] aacraid: Add Power Management support
reproduce:
        # apt-get install sparse
        git checkout de665f28f788ad72ff6a0ce6ac2721d77248b7cf
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/scsi/aacraid/linit.c:1321:6: sparse: symbol 'aac_release_resources' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
