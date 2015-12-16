From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 00/17] lpfc: Update to revision 11.0.0.10
Date: Wed, 16 Dec 2015 18:11:51 -0500
Message-ID: <5671efb7.4urkMzb5xQylW142%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34138 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbbLPXMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 18:12:10 -0500
Received: by mail-pf0-f173.google.com with SMTP id 68so19521014pfc.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2015 15:12:09 -0800 (PST)
Received: from myfc17 (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id 62sm7011787pfq.90.2015.12.16.15.12.08
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 16 Dec 2015 15:12:08 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 11.0.0.10

The patches were cut against scsi-misc

James Smart (17):
  Fix FCF Infinite loop in lpfc_sli4_fcf_rr_next_index_get.
  Fix the FLOGI discovery logic to comply with T11 standards
  Added throttle logging support.
  Fix RegLogin failed error seen on Lancer FC during port bounce
  Fix driver crash when module parameter lpfc_fcp_io_channel set to 16
  Fix crash in fcp command completion path.
  Modularize and cleanup FDMI code in driver
  Fix RDP Speed reporting.
  Fix RDP ACC being too long.
  Make write check error processing more resilient
  Use new FDMI speed definitions for 10G, 25G and 40G FCoE.
  Fix mbox reuse in PLOGI completion
  Fix external loopback failure.
  Add logging for misconfigured optics.
  Delete unnecessary checks before the function call "mempool_destroy"
  Use kzalloc instead of kmalloc
  Update version to 11.0.0.10 for upstream patch set

 drivers/scsi/lpfc/lpfc.h           |   21 +-
 drivers/scsi/lpfc/lpfc_attr.c      |   66 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |    7 +-
 drivers/scsi/lpfc/lpfc_ct.c        | 1864 +++++++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_disc.h      |   11 +
 drivers/scsi/lpfc/lpfc_els.c       |  484 +++++-----
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   88 +-
 drivers/scsi/lpfc/lpfc_hw.h        |  184 +++-
 drivers/scsi/lpfc/lpfc_hw4.h       |   52 +-
 drivers/scsi/lpfc/lpfc_init.c      |  268 ++++--
 drivers/scsi/lpfc/lpfc_logmsg.h    |   40 +
 drivers/scsi/lpfc/lpfc_mem.c       |    6 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  134 ++-
 drivers/scsi/lpfc/lpfc_scsi.c      |   82 +-
 drivers/scsi/lpfc/lpfc_sli.c       |   30 +-
 drivers/scsi/lpfc/lpfc_sli4.h      |    1 +
 drivers/scsi/lpfc/lpfc_version.h   |    2 +-
 drivers/scsi/lpfc/lpfc_vport.c     |    8 +
 18 files changed, 2186 insertions(+), 1162 deletions(-)

-- 
1.7.11.7

