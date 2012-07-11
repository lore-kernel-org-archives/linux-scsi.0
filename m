From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PATCH 0/4] isci update for 3.6
Date: Wed, 11 Jul 2012 14:59:24 -0700
Message-ID: <20120711215901.26813.19955.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53318 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933272Ab2GKVmg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2012 17:42:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

James,

This is the backlog of the libsas indepedent driver changes for 3.6.  Just a
small collection of fixlets.  Please pull, thanks.

--
Dan


The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git tags/isci-for-3.6

for you to fetch changes up to 6734092e66011def7875bd67beef889d0fee1cc9:

  isci: add a couple __iomem annotations (2012-07-03 12:09:32 -0700)


----------------------------------------------------------------
isci update for 3.6

1/ Fix the workaround for drives that have a slow response to COMSAS.
   Drives with this problem intermittently take a long time to be
   identified, or fail to be identified altogether.

2/ A minor fix for the efi variable code failure path

3/ A handful of smatch fixups from Dan Carpenter

----------------------------------------------------------------
Dan Carpenter (2):
      isci: make function declaration match implementation
      isci: add a couple __iomem annotations

Dan Williams (1):
      isci: fix isci_pci_probe() generates warning on efi failure path

Dave Maurer (1):
      isci: fix COMSAS negation timout workaround for WD SAS drives

 drivers/scsi/isci/host.c                | 2 +-
 drivers/scsi/isci/init.c                | 1 -
 drivers/scsi/isci/phy.c                 | 4 +++-
 drivers/scsi/isci/probe_roms.c          | 1 -
 drivers/scsi/isci/remote_node_context.h | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)
