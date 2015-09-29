From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 31/36] scsi: rescan VPD attributes
Date: Tue, 29 Sep 2015 21:40:46 +0800
Message-ID: <201509292131.z5qOJPe3%fengguang.wu@intel.com>
References: <1443523658-87622-32-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39101 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965121AbbI2Nlr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 09:41:47 -0400
Content-Disposition: inline
In-Reply-To: <1443523658-87622-32-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

Hi Hannes,

[auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]


coccinelle warnings: (new ones prefixed by >>)

>> drivers/scsi/scsi.c:888:3-8: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
