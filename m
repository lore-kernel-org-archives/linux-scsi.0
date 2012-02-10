From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v1 0/5] isci updates for -next
Date: Fri, 10 Feb 2012 01:18:29 -0800
Message-ID: <20120210091814.26719.75603.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25870 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758615Ab2BJJDk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2012 04:03:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a resend of the T10 DIF and clock gating patches (checkpatch
fixups), some debug updates, and a fix for driver load/unload testing.

This is based on branch of the pending libsas changes as it grew an
entanglement with the phy reference counting and lldd_port reworks.

---

Andrzej Jakowski (1):
      isci: improvements in driver unloading routine

Dan Williams (2):
      isci: debug, provide state-enum-to-string conversions
      isci: improve phy event warnings

Dave Jiang (1):
      isci: T10 DIF support

Marcin Tomczak (1):
      isci: enable clock gating


 drivers/scsi/isci/host.c                |    9 +
 drivers/scsi/isci/init.c                |   10 +
 drivers/scsi/isci/phy.c                 |  157 +++++++++++++---------
 drivers/scsi/isci/phy.h                 |  154 ++++++++--------------
 drivers/scsi/isci/port.c                |   46 ++++---
 drivers/scsi/isci/port.h                |  103 ++++++---------
 drivers/scsi/isci/registers.h           |   27 ++++
 drivers/scsi/isci/remote_device.c       |   50 ++++---
 drivers/scsi/isci/remote_device.h       |  205 +++++++++++++----------------
 drivers/scsi/isci/remote_node_context.c |   19 +--
 drivers/scsi/isci/remote_node_context.h |   97 ++++++--------
 drivers/scsi/isci/request.c             |  172 +++++++++++++++++++++++-
 drivers/scsi/isci/request.h             |  219 +++++++++++++------------------
 drivers/scsi/isci/scu_task_context.h    |   55 ++++++--
 14 files changed, 732 insertions(+), 591 deletions(-)
