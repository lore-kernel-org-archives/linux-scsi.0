From: <kgudipat@brocade.com>
Subject: [PATCH 00/15] bfa: Update the driver version to 3.0.2.1
Date: Fri, 24 Jun 2011 20:22:17 -0700
Message-ID: <1308972137-3588-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:57474 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218Ab1FYDWa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2011 23:22:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Hi James,

	The following patch set enhances support for Brocade-1860 Fabric Adapter

	and updates the Brocade BFA driver to v3.0.2.1.

	I have compiled & tested the code against your scsi-misc and

	linux-next (3.0.0-rc2-next-20110610-0.7-default).

	Please note that this patch-set needs to be applied after the one I

	submitted on 06/13/2011:

	http://marc.info/?l=linux-scsi&m=130800569632565&w=2

Thanks,
Krishna C Gudipati.

Krishna Gudipati (15):
	bfa: Enable ASIC block configuration and query.
	bfa: IOC bug fixes.
	bfa: Added Fabric Assigned Address(FAA) support
	bfa: Brocade-1860 Fabric Adapter PLL init fixes
	bfa: Brocade-1860 Fabric Adapter vHBA support
	bfa: DMA memory allocation enhancement
	bfa: FCS bug fixes
	bfa: Extend BSG interface
	bfa: Added support for CEE info and stats query
	bfa: Added support to obtain SFP info
	bfa: Added support for flash configuration
	bfa: Added HBA diagnostics support
	bfa: Added support to query PHY
	bfa: Driver and BSG enhancements
	bfa: Update the driver version to 3.0.2.1

 drivers/scsi/bfa/bfa.h           |  117 +-
 drivers/scsi/bfa/bfa_core.c      |  652 +++++++---
 drivers/scsi/bfa/bfa_defs.h      |  553 ++++++++-
 drivers/scsi/bfa/bfa_defs_fcs.h  |   27 +-
 drivers/scsi/bfa/bfa_defs_svc.h  |  163 +++-
 drivers/scsi/bfa/bfa_fcbuild.c   |   31 +
 drivers/scsi/bfa/bfa_fcbuild.h   |    4 +
 drivers/scsi/bfa/bfa_fcpim.c     |  255 +++-
 drivers/scsi/bfa/bfa_fcpim.h     |   36 +-
 drivers/scsi/bfa/bfa_fcs.c       |   22 +-
 drivers/scsi/bfa/bfa_fcs.h       |   22 +-
 drivers/scsi/bfa/bfa_fcs_fcpim.c |   10 +
 drivers/scsi/bfa/bfa_fcs_lport.c |  174 +++-
 drivers/scsi/bfa/bfa_fcs_rport.c |   85 ++-
 drivers/scsi/bfa/bfa_hw_cb.c     |   12 +-
 drivers/scsi/bfa/bfa_ioc.c       | 2679 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/bfa/bfa_ioc.h       |  436 ++++++-
 drivers/scsi/bfa/bfa_ioc_cb.c    |   15 -
 drivers/scsi/bfa/bfa_ioc_ct.c    |  207 ++--
 drivers/scsi/bfa/bfa_modules.h   |   20 +-
 drivers/scsi/bfa/bfa_port.c      |  366 ++++++
 drivers/scsi/bfa/bfa_port.h      |   57 +
 drivers/scsi/bfa/bfa_svc.c       | 1015 +++++++++++----
 drivers/scsi/bfa/bfa_svc.h       |  142 ++-
 drivers/scsi/bfa/bfad.c          |  186 ++--
 drivers/scsi/bfa/bfad_bsg.c      | 1459 ++++++++++++++++++++-
 drivers/scsi/bfa/bfad_bsg.h      |  376 ++++++-
 drivers/scsi/bfa/bfad_debugfs.c  |   14 +-
 drivers/scsi/bfa/bfad_drv.h      |   24 +-
 drivers/scsi/bfa/bfad_im.c       |    7 +-
 drivers/scsi/bfa/bfi.h           |  544 ++++++++-
 drivers/scsi/bfa/bfi_ms.h        |   65 +-
 drivers/scsi/bfa/bfi_reg.h       |   11 +
 33 files changed, 8802 insertions(+), 984 deletions(-)

-- 
1.7.3.rc1

