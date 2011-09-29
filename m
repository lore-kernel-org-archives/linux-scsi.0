From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PATCH 0/2] isci fixes for 3.1-rc
Date: Wed, 28 Sep 2011 18:35:21 -0700
Message-ID: <20110929013227.23410.28489.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:34026 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab1I2BfW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 21:35:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: dmilburn@redhat.com, dave.jiang@intel.com, hare@suse.de, linux-scsi@vger.kernel.org

The following changes since commit 96067723e46b0dd24ae7b934085ab4eff4d26a1b:

  [SCSI] 3w-9xxx: fix iommu_iova leak (2011-09-26 09:28:58 -0500)

are available in the git repository at:
  git://github.com:djbw/linux.git isci-fixes

Dan Williams (1):
      isci: fix support for large smp requests

Jeff Skirvin (1):
      isci: fix missed unlock in apc_agent_timeout()

 drivers/scsi/isci/isci.h        |    2 +-
 drivers/scsi/isci/port_config.c |    2 +-
 drivers/scsi/isci/request.c     |   49 ++++++++++++++++-----------------------
 drivers/scsi/isci/request.h     |    3 --
 drivers/scsi/isci/sas.h         |    2 -
 5 files changed, 22 insertions(+), 36 deletions(-)
