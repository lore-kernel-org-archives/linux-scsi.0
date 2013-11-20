From: <vmohan@brocade.com>
Subject: [PATCH 0/8] bfa driver update to v3.2.23.0
Date: Tue, 19 Nov 2013 23:05:38 -0800
Message-ID: <1384931146-3702-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:1424 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858Ab3KTHxN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Nov 2013 02:53:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: agurumur@brocade.com, james.bottomley@hansenpartnership.com

From: Vijaya Mohan Guvva <vmohan@brocade.com>

Hi James,
The following patch-set includes, firmware patch simplification feature,
bug fixes, changes to use new firmware images v3.2.3.0 and changes to
update the driver version to 3.2.23.0.

I have compiled and tested the patches against 3.12 kernel.
Please review and provide your comments.

Thanks,
Vijaya Mohan Guvva

Vijaya Mohan Guvva (8):
  bfa: Firmware patch simplification
  bfa: Register port with SCSI even on port init failure
  bfa: LUN discovery issue in direct attach mode
  bfa: Fix for bcu or hcm faa query hang
  bfa: Observed auto D-port mode instead of manual
  bfa: change FC_ELS_TOV to 20sec
  bfa: Fix crash when symb name set for offline vport
  bfa: Driver version upgrade to 3.2.23.0

 drivers/scsi/bfa/bfa_core.c      |   8 +-
 drivers/scsi/bfa/bfa_defs.h      |   1 +
 drivers/scsi/bfa/bfa_fc.h        |   2 +-
 drivers/scsi/bfa/bfa_fcs.h       |   1 +
 drivers/scsi/bfa/bfa_fcs_lport.c |  29 +-
 drivers/scsi/bfa/bfa_ioc.c       | 727 ++++++++++++++++++++++++++++++++++++---
 drivers/scsi/bfa/bfa_ioc.h       |   7 +-
 drivers/scsi/bfa/bfa_ioc_cb.c    |  23 ++
 drivers/scsi/bfa/bfa_svc.c       |   2 +-
 drivers/scsi/bfa/bfad.c          |  91 +++--
 drivers/scsi/bfa/bfad_attr.c     |   7 +-
 drivers/scsi/bfa/bfad_bsg.c      |  15 +
 drivers/scsi/bfa/bfad_bsg.h      |   1 +
 drivers/scsi/bfa/bfad_drv.h      |   6 +-
 drivers/scsi/bfa/bfi.h           |  42 ++-
 15 files changed, 850 insertions(+), 112 deletions(-)

-- 
1.8.2.1

