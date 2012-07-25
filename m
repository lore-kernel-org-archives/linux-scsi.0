From: "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>
Subject: RE: [GIT PATCH 0/4] isci update for 3.6
Date: Wed, 25 Jul 2012 23:08:58 +0000
Message-ID: <71F80D142B3A3F4BA71741C00BED691D248996C8@FMSMSX102.amr.corp.intel.com>
References: <20120711215901.26813.19955.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31617 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab2GYXJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2012 19:09:05 -0400
In-Reply-To: <20120711215901.26813.19955.stgit@dwillia2-linux.jf.intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "JBottomley@parallels.com" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


James, is there any update available about the pull of the driver changes that
Dan mentioned?  Please let me know if there is anything we need to do to assist.

Regards,




-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Dan Williams
Sent: Wednesday, July 11, 2012 2:59 PM
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org
Subject: [GIT PATCH 0/4] isci update for 3.6

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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
