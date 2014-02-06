From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/4] isci, libsas fixes for 3.4-rc2
Date: Thu, 06 Feb 2014 12:22:55 -0800
Message-ID: <20140206202151.5227.12582.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47094 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbaBFUXB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Feb 2014 15:23:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: artur.paszkiewicz@intel.com, dave.jiang@intel.com, lukasz.dorau@intel.com, JBottomley@Parallels.com

Hi James,

Here are some collected fixes.  All but patch 2 are tagged for -stable.

Patch 1 and 4 have been on the list since before the 3.14 merge window,
patch 2 and 3 are new.

Please apply, thank you.

[PATCH 1/4] isci: fix reset timeout handling
[PATCH 2/4] scsi, libsas: introduce scmd_dbg() to quiet false positive "timeout" messages
[PATCH 3/4] isci: fix needless ata reset escalations
[PATCH 4/4] isci: correct erroneous for_each_isci_host macro

 drivers/scsi/isci/host.h            |    5 ++---
 drivers/scsi/isci/port_config.c     |    7 -------
 drivers/scsi/isci/request.c         |    8 ++------
 drivers/scsi/isci/task.c            |    2 +-
 drivers/scsi/libsas/sas_scsi_host.c |    2 +-
 include/scsi/scsi_device.h          |   12 ++++++++++++
 6 files changed, 18 insertions(+), 18 deletions(-)
