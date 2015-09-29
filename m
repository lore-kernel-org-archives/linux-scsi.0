From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 33/36] scsi: Add 'access_state' attribute
Date: Tue, 29 Sep 2015 21:51:26 +0800
Message-ID: <201509292134.7QZ7bWBj%fengguang.wu@intel.com>
References: <1443523658-87622-34-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49007 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965201AbbI2Nv6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 09:51:58 -0400
Content-Disposition: inline
In-Reply-To: <1443523658-87622-34-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

Hi Hannes,

[auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]

reproduce:
  # apt-get install sparse
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/scsi/scsi_sysfs.c:98:12: sparse: symbol 'scsi_access_state_name' was not declared. Should it be static?
   drivers/scsi/scsi_sysfs.c:230:25: sparse: symbol 'dev_attr_hstate' was not declared. Should it be static?
   drivers/scsi/scsi_sysfs.c:405:24: sparse: symbol 'scsi_shost_attr_group' was not declared. Should it be static?
   drivers/scsi/scsi_sysfs.c:806:1: sparse: incompatible types in comparison expression (different address spaces)
   drivers/scsi/scsi_sysfs.c:807:1: sparse: incompatible types in comparison expression (different address spaces)

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
