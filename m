From: Dan Williams <dan.j.williams@intel.com>
Subject: [set3 PATCH 0/6] libsas: domain discovery fixes + misc cleanups
Date: Thu, 21 Jun 2012 23:36:04 -0700
Message-ID: <20120622063604.21332.39275.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:28560 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab2FVGT0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jun 2012 02:19:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Set3 of 5 patchsets to update scsi, libsas, and libata in
support of the isci driver.

Some fixes to domain (re-)discovery failures and some random cleanups.

---

Dan Carpenter (1):
      mvsas: remove unused variable in mvs_task_exec()

Dan Williams (4):
      libsas: continue revalidation
      libsas: fix sas_discover_devices return code handling
      libsas: drop sata port multiplier infrastructure
      libsas: trim sas_task of slow path infrastructure

Jeff Skirvin (1):
      libsas: sas_rediscover_dev did not look at the SMP exec status.


 drivers/scsi/libsas/sas_discover.c  |    6 ---
 drivers/scsi/libsas/sas_expander.c  |   74 +++++++++++++++--------------------
 drivers/scsi/libsas/sas_init.c      |   23 ++++++++++-
 drivers/scsi/libsas/sas_scsi_host.c |    8 +++-
 drivers/scsi/mvsas/mv_sas.c         |   21 +++++-----
 drivers/scsi/pm8001/pm8001_sas.c    |   34 ++++++++--------
 include/scsi/libsas.h               |   15 ++++---
 7 files changed, 95 insertions(+), 86 deletions(-)
