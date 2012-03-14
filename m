From: <kgudipat@brocade.com>
Subject: [PATCH 0/9] bfa: Update the driver version to 3.0.23.0
Date: Tue, 13 Mar 2012 17:37:03 -0700
Message-ID: <1331685423-20612-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:52974 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752328Ab2CNB3X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Mar 2012 21:29:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Hi James,

	The following patch set includes bug fixes, revised implementation of
	Fabric Assigned Address (FAA) feature and updates the Brocade BFA driver
	to v3.0.23.0.

	Please note that this patch-set depends on the following patch:
	http://marc.info/?l=linux-scsi&m=133105374131733&w=2

	I have compiled & tested the code against your scsi-misc and
	linux-next (3.3.0-rc5-0.7-default).

Thanks,
Krishna C Gudipati.

Krishna Gudipati (9):
  bfa: Add fc host issue lip support
  bfa: Modify ISR to process pending completions
  bfa: Serialize the IOC hw semaphore unlock logic.
  bfa: Flash controller IOC pll init fixes.
  bfa: Revised Fabric Assigned Address(FAA) feature implementation.
  bfa: Move service parameter programming logic into firmware.
  bfa: Fix to avoid vport delete hang on request queue full scenario.
  bfa: BSG and User interface fixes.
  bfa: Update the driver version to 3.0.23.0

 drivers/scsi/bfa/bfa.h           |    9 +-
 drivers/scsi/bfa/bfa_core.c      |  693 ++++++++++++++++++++++++++------------
 drivers/scsi/bfa/bfa_defs_svc.h  |    2 +-
 drivers/scsi/bfa/bfa_fcs_lport.c |    2 +
 drivers/scsi/bfa/bfa_fcs_rport.c |    5 +-
 drivers/scsi/bfa/bfa_ioc.c       |  188 ++++-------
 drivers/scsi/bfa/bfa_ioc.h       |   17 +-
 drivers/scsi/bfa/bfa_ioc_ct.c    |  151 ++++++---
 drivers/scsi/bfa/bfa_svc.c       |   71 ++---
 drivers/scsi/bfa/bfa_svc.h       |    4 -
 drivers/scsi/bfa/bfad_attr.c     |   47 +++-
 drivers/scsi/bfa/bfad_bsg.c      |   57 +---
 drivers/scsi/bfa/bfad_bsg.h      |    2 -
 drivers/scsi/bfa/bfad_drv.h      |    2 +-
 drivers/scsi/bfa/bfi_ms.h        |   17 +-
 drivers/scsi/bfa/bfi_reg.h       |    6 +
 16 files changed, 776 insertions(+), 497 deletions(-)

-- 
1.7.3.rc1

