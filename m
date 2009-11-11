From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 00/17] hpsa driver updates
Date: Wed, 11 Nov 2009 10:50:22 -0600
Message-ID: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:25075 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbZKKQs4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2009 11:48:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com

The following series implements hpsa scsi driver for HP Smart Arrays,
and some updates since the last time.
The first 5 patches in the series are already in Andrew Morton's tree.

---

Andrew Morton (1):
      avoid helpful cleanup patches.

Stephen M. Cameron (16):
      hpsa: fix typo that causes scsi status to be lost
      hpsa:  Make fill_cmd() return void
      hpsa: Remove sendcmd, in no case are we required to poll for completions.
      hpsa: Flush cache with interrupts still enabled.
      hpsa: Retry driver initiated commands on unit attention
      hpsa: decode unit attention condition and retry commands.
      hpsa: Make hpsa_sdev_attrs static
      hpsa:  Allow device rescan to be triggered via sysfs.
      Add thread to allow controllers to register for rescan for new devices
      hpsa: Factor out some pci_unmap code
      hpsa: Factor out command submission sequence
      hpsa: Use shost_priv instead of accessing host->hostdata[0] directly.
      hpsa: Allocate the correct amount of extra space for the scsi host
      Fix use of unallocated memory for MSA2xxx enclosure device data.
      hpsa: Fix vendor id check
      Add hpsa driver for HP Smart Array controllers.


 drivers/scsi/Kconfig    |   10 
 drivers/scsi/Makefile   |    1 
 drivers/scsi/hpsa.c     | 3531 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/hpsa.h     |  273 ++++
 drivers/scsi/hpsa_cmd.h |  326 ++++
 5 files changed, 4141 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/hpsa.c
 create mode 100644 drivers/scsi/hpsa.h
 create mode 100644 drivers/scsi/hpsa_cmd.h

-- 
-- steve
