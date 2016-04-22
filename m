From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 0/5] mpt3sas: driver update for Phase12
Date: Fri, 22 Apr 2016 16:53:09 +0530
Message-ID: <1461324194-5789-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36131 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbcDVLXb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2016 07:23:31 -0400
Received: by mail-pa0-f46.google.com with SMTP id er2so39043108pad.3
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2016 04:23:30 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-kernel@vger.kernel.org, Chaitra P B <chaitra.basappa@broadcom.com>

Here is the change list:
* Updated MPI version and MPI header files.
* Handle active cable exception event for Intruder/Cutlass HBAs.
* Use scsi_prot_ref_tag()API to fill reference tag field in the CDB.
* Set maximum transfer length per IO on RAID volumes to 4MB.
* Use "synchronize_irq()"API to handle Asynchronous TM's completion

Chaitra P B (5):
  mpt3sas: Update MPI header to 2.00.42
  mpt3sas: Handle active cable exception event
  mpt3sas: Fix initial Reference tag field for 4K PI drives.
  mpt3sas: Set maximum transfer length per IO to 4MB for VDs
  mpt3sas: Used "synchronize_irq()"API to synchronize timed-out IO &
    TMs

 drivers/scsi/mpt3sas/mpi/mpi2.h      |  7 +++++--
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 18 +++++++++++-----
 drivers/scsi/mpt3sas/mpi/mpi2_init.h | 15 +++++++++++---
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h  | 40 +++++++++++++++++++++++++++++++-----
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 20 ++++++++++--------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  5 ++++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 27 ++++++++++++++++++++++--
 7 files changed, 106 insertions(+), 26 deletions(-)

-- 
1.8.3.1

