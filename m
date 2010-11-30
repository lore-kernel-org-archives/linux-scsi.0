From: Maggie <xmzhang@brocade.com>
Subject: [PATCH 0/2] bfa fix sparse check warnings
Date: Mon, 29 Nov 2010 18:17:36 -0800
Message-ID: <1291083456-10796-1-git-send-email-xmzhang@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:44336 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764Ab0K3Cka (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2010 21:40:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@blc-10-10.brocade.com, Maggie <xmzhang@brocade.com>

This patch set fixes sparse check warnings. The first patch fixes all regular
sparse check warning, and the second patch is the first round of fix for the 
endianess check warnings from make C=2 CF="-D__CHECK_ENDIAN__".

Maggie (2):
  bfa: fix regular sparse check warnings.
  bfa: fix endianess sparse check warnings

 drivers/scsi/bfa/bfa_cb_ioim.h   |    2 +-
 drivers/scsi/bfa/bfa_defs_svc.h  |    8 +-
 drivers/scsi/bfa/bfa_fc.h        |   50 ++++----
 drivers/scsi/bfa/bfa_fcbuild.c   |   44 ++++----
 drivers/scsi/bfa/bfa_fcbuild.h   |   28 +++---
 drivers/scsi/bfa/bfa_fcs.h       |   14 +-
 drivers/scsi/bfa/bfa_fcs_lport.c |  232 +++++++++++++++++++-------------------
 drivers/scsi/bfa/bfa_fcs_rport.c |   10 +--
 drivers/scsi/bfa/bfa_ioc.c       |    5 +-
 drivers/scsi/bfa/bfa_ioc.h       |   10 +-
 drivers/scsi/bfa/bfa_ioc_cb.c    |    2 +-
 drivers/scsi/bfa/bfa_ioc_ct.c    |    2 +-
 drivers/scsi/bfa/bfa_port.c      |    2 +-
 drivers/scsi/bfa/bfa_svc.c       |    4 +-
 drivers/scsi/bfa/bfad.c          |    4 +-
 drivers/scsi/bfa/bfad_attr.c     |    8 +-
 drivers/scsi/bfa/bfad_debugfs.c  |   42 ++++++-
 drivers/scsi/bfa/bfad_drv.h      |    6 +-
 drivers/scsi/bfa/bfi.h           |    4 +-
 drivers/scsi/bfa/bfi_ms.h        |   50 ++++----
 20 files changed, 277 insertions(+), 250 deletions(-)

-- 
1.7.2.1

