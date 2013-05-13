From: Vijaya Mohan Guvva <vmohan@brocade.com>
Subject: [PATCH V1 00/17] Update the driver version to 3.2.21.1
Date: Mon, 13 May 2013 02:33:18 -0700
Message-ID: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:50532 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873Ab3EMJ45 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 05:56:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, adapter_linux_open_src_team@Brocade.COM, Vijaya Mohan Guvva <vmohan@Brocade.COM>

Hi James,
Re-submitting the patch sets, Update the driver version to 3.2.21.0 and
Update the driver version to 3.2.21.1.
It includes bug-fixes, changes to use firmware version 3.2.1.0, adds new
features such as Forward Error Correction, FC BB credit recovery, dynamic
diagnostic Port (D-port), enabled support for new hardware - chinook quad
and updates the Brocade BFA driver to v3.2.21.1.

Thanks,
Vijaya Mohan Guvva

Vijaya Mohan Guvva (17):
  bfa: Support for FC BB credit recovery
  bfa: Forward Error Correction status query
  bfa: Add dynamic diagnostic port support
  bfa: Fix WARN_ON condition check
  bfa: FDMI enhancements
  bfa: Fix 1860 port initialize when ATC is enabled
  bfa: Fix FDISC timeout handling
  bfa: kdump fix on 815 and 825 adapters
  bfa: driver compatibility with 32bit libs
  bfa: fru vpd date update changes
  bfa: firmware statistics update
  bfa: Allow rsp queue process during ioc disable
  bfa: Fix bug_on condition in RPSC rsp handling
  bfa: fix endianess issue for firmware stats
  bfa: Support for chinook-quad port card
  bfa: dis-associate bfa path_tov with dev_loss_tmo
  bfa: Update the driver version to 3.2.21.1

 drivers/scsi/bfa/bfa_core.c      |   3 +-
 drivers/scsi/bfa/bfa_defs.h      | 103 +++++-
 drivers/scsi/bfa/bfa_defs_svc.h  |  77 ++++-
 drivers/scsi/bfa/bfa_fc.h        |  15 +
 drivers/scsi/bfa/bfa_fcpim.c     |   2 +-
 drivers/scsi/bfa/bfa_fcs.c       |  62 +---
 drivers/scsi/bfa/bfa_fcs.h       |  34 +-
 drivers/scsi/bfa/bfa_fcs_lport.c | 209 +++++++++++-
 drivers/scsi/bfa/bfa_fcs_rport.c |   7 +-
 drivers/scsi/bfa/bfa_ioc.c       |  74 +++--
 drivers/scsi/bfa/bfa_ioc.h       |   9 +-
 drivers/scsi/bfa/bfa_ioc_cb.c    |  86 ++++-
 drivers/scsi/bfa/bfa_ioc_ct.c    |  46 +++
 drivers/scsi/bfa/bfa_svc.c       | 698 ++++++++++++++++++++++++++++++++++++---
 drivers/scsi/bfa/bfa_svc.h       |  34 +-
 drivers/scsi/bfa/bfad.c          |  14 +-
 drivers/scsi/bfa/bfad_attr.c     |  33 +-
 drivers/scsi/bfa/bfad_bsg.c      | 137 +++++---
 drivers/scsi/bfa/bfad_bsg.h      |  52 ++-
 drivers/scsi/bfa/bfad_drv.h      |   2 +-
 drivers/scsi/bfa/bfi.h           |  78 ++++-
 drivers/scsi/bfa/bfi_ms.h        |   5 +-
 22 files changed, 1498 insertions(+), 282 deletions(-)

-- 
1.7.12

