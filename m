From: <anil.gurumurthy@qlogic.com>
Subject: [PATCH RESEND 0/4] bfa: Patches for scsi "misc" branch
Date: Tue, 3 Feb 2015 03:44:59 -0500
Message-ID: <1422953103-5470-1-git-send-email-anil.gurumurthy@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:29203 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693AbbBCJYP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2015 04:24:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org

Hi James, Christoph,

Re-sending the patches to move user visible strings to a separate patch.
Please apply the following patches to the scsi tree, misc branch  at your
earliest convenience.

Thanks,
Anil

Anil Gurumurthy (4):
  bfa:Updating copyright messages
  bfa:Fix for crash when bfa_itnim is NULL
  bfa:File header and user visible string changes
  bfa:Update driver version to 3.2.25.0

 drivers/scsi/bfa/bfa.h           |    7 ++--
 drivers/scsi/bfa/bfa_core.c      |    7 ++--
 drivers/scsi/bfa/bfa_cs.h        |    7 ++--
 drivers/scsi/bfa/bfa_defs.h      |    7 ++--
 drivers/scsi/bfa/bfa_defs_fcs.h  |    7 ++--
 drivers/scsi/bfa/bfa_defs_svc.h  |    7 ++--
 drivers/scsi/bfa/bfa_fc.h        |    7 ++--
 drivers/scsi/bfa/bfa_fcbuild.c   |    7 ++--
 drivers/scsi/bfa/bfa_fcbuild.h   |    7 ++--
 drivers/scsi/bfa/bfa_fcpim.c     |    7 ++--
 drivers/scsi/bfa/bfa_fcpim.h     |    7 ++--
 drivers/scsi/bfa/bfa_fcs.c       |    7 ++--
 drivers/scsi/bfa/bfa_fcs.h       |    9 +++--
 drivers/scsi/bfa/bfa_fcs_fcpim.c |    7 ++--
 drivers/scsi/bfa/bfa_fcs_lport.c |    9 +++--
 drivers/scsi/bfa/bfa_fcs_rport.c |    7 ++--
 drivers/scsi/bfa/bfa_hw_cb.c     |    7 ++--
 drivers/scsi/bfa/bfa_hw_ct.c     |    7 ++--
 drivers/scsi/bfa/bfa_ioc.c       |    9 +++--
 drivers/scsi/bfa/bfa_ioc.h       |    7 ++--
 drivers/scsi/bfa/bfa_ioc_cb.c    |    7 ++--
 drivers/scsi/bfa/bfa_ioc_ct.c    |    7 ++--
 drivers/scsi/bfa/bfa_modules.h   |    7 ++--
 drivers/scsi/bfa/bfa_plog.h      |    7 ++--
 drivers/scsi/bfa/bfa_port.c      |    7 ++--
 drivers/scsi/bfa/bfa_port.h      |    7 ++--
 drivers/scsi/bfa/bfa_svc.c       |    7 ++--
 drivers/scsi/bfa/bfa_svc.h       |    7 ++--
 drivers/scsi/bfa/bfad.c          |   24 +++++-------
 drivers/scsi/bfa/bfad_attr.c     |   75 +++++++++++++++++++-------------------
 drivers/scsi/bfa/bfad_bsg.c      |    7 ++--
 drivers/scsi/bfa/bfad_bsg.h      |    7 ++--
 drivers/scsi/bfa/bfad_debugfs.c  |    7 ++--
 drivers/scsi/bfa/bfad_drv.h      |    9 +++--
 drivers/scsi/bfa/bfad_im.c       |   35 ++++++++++++++++--
 drivers/scsi/bfa/bfad_im.h       |    7 ++--
 drivers/scsi/bfa/bfi.h           |    7 ++--
 drivers/scsi/bfa/bfi_ms.h        |    7 ++--
 drivers/scsi/bfa/bfi_reg.h       |    9 +++--
 39 files changed, 228 insertions(+), 168 deletions(-)

