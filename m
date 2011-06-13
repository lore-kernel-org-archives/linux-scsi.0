From: <kgudipat@brocade.com>
Subject: [PATCH 00/12] bfa: Update bfa driver to version 3.0.2.0
Date: Mon, 13 Jun 2011 15:39:24 -0700
Message-ID: <1308004764-13616-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:59127 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753922Ab1FMWyv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2011 18:54:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Hi James,

	The following patch set adds support for Brocade-1860 Fabric Adapter and

	updates the Brocade BFA driver to v3.0.2.0.

	I have compiled & tested the code against your scsi-misc and

	linux-next (3.0.0-rc2-next-20110610-0.7-default).

Thanks,
Krishna C Gudipati.

Krishna Gudipati (12):
  bfa: Introduced generic address len pair to represent DMA memory
    chunk.
  bfa: Introduce IOC event notification mechanism.
  bfa: Add pbc port disable check and fix LPS message name
  bfa: Brocade-1860 Fabric Adapter Hardware Enablement
  bfa: Changes to support vport disable and enable operations.
  bfa: IOC and pll init changes for Brocade-1860 Fabric Adapter.
  bfa: Brocade-1860 Fabric Adapter 16Gbs support and flash controller fixes.
  bfa: FC credit recovery and misc bug fixes.
  bfa: Enhancement for fcpim and IO tag handling.
  bfa: Driver initialization and model description fix
  bfa: Add BSG interface to support ELS, CT and vendor commands.
  bfa: Update the driver version to 3.0.2.0

 drivers/scsi/bfa/Makefile        |    2 +-
 drivers/scsi/bfa/bfa.h           |   29 +-
 drivers/scsi/bfa/bfa_core.c      |  244 ++++++++-----
 drivers/scsi/bfa/bfa_defs.h      |   34 ++-
 drivers/scsi/bfa/bfa_defs_svc.h  |   11 +-
 drivers/scsi/bfa/bfa_fc.h        |   11 +-
 drivers/scsi/bfa/bfa_fcbuild.c   |   18 +-
 drivers/scsi/bfa/bfa_fcbuild.h   |   12 +-
 drivers/scsi/bfa/bfa_fcpim.c     |  283 ++++++++++----
 drivers/scsi/bfa/bfa_fcpim.h     |   69 +++-
 drivers/scsi/bfa/bfa_fcs.c       |  135 ++++++-
 drivers/scsi/bfa/bfa_fcs.h       |    9 +
 drivers/scsi/bfa/bfa_fcs_lport.c |  155 ++++++++-
 drivers/scsi/bfa/bfa_fcs_rport.c |   38 +--
 drivers/scsi/bfa/bfa_hw_cb.c     |   84 +++--
 drivers/scsi/bfa/bfa_hw_ct.c     |   89 ++---
 drivers/scsi/bfa/bfa_ioc.c       |  387 +++++++++++--------
 drivers/scsi/bfa/bfa_ioc.h       |  173 +++++----
 drivers/scsi/bfa/bfa_ioc_cb.c    |   56 ++--
 drivers/scsi/bfa/bfa_ioc_ct.c    |  473 +++++++++++++++++++----
 drivers/scsi/bfa/bfa_modules.h   |    7 +-
 drivers/scsi/bfa/bfa_port.c      |   62 ++-
 drivers/scsi/bfa/bfa_port.h      |    5 +-
 drivers/scsi/bfa/bfa_svc.c       |  121 ++++---
 drivers/scsi/bfa/bfa_svc.h       |    9 +-
 drivers/scsi/bfa/bfad.c          |  119 ++++---
 drivers/scsi/bfa/bfad_attr.c     |   53 +++-
 drivers/scsi/bfa/bfad_bsg.c      |  768 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfad_bsg.h      |  135 +++++++
 drivers/scsi/bfa/bfad_drv.h      |    6 +-
 drivers/scsi/bfa/bfad_im.c       |   25 +-
 drivers/scsi/bfa/bfad_im.h       |    3 +
 drivers/scsi/bfa/bfi.h           |  103 ++++--
 drivers/scsi/bfa/bfi_cbreg.h     |  305 ---------------
 drivers/scsi/bfa/bfi_ctreg.h     |  636 -------------------------------
 drivers/scsi/bfa/bfi_ms.h        |   98 ++++--
 drivers/scsi/bfa/bfi_reg.h       |  439 ++++++++++++++++++++++
 37 files changed, 3343 insertions(+), 1863 deletions(-)
 create mode 100644 drivers/scsi/bfa/bfad_bsg.c
 create mode 100644 drivers/scsi/bfa/bfad_bsg.h
 delete mode 100644 drivers/scsi/bfa/bfi_cbreg.h
 delete mode 100644 drivers/scsi/bfa/bfi_ctreg.h
 create mode 100644 drivers/scsi/bfa/bfi_reg.h

-- 
1.7.3.rc1

