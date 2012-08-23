From: <kgudipat@brocade.com>
Subject: [PATCH 00/10] bfa: Update the driver version to v3.1.2.0
Date: Wed, 22 Aug 2012 19:50:10 -0700
Message-ID: <1345690210-20346-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:58994 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685Ab2HWCuc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 22:50:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Hi James,

	The following patch-set includes bug-fixes and also adds new features to BFA
	such as PCIE - AER handling support, FCS remote port enhancements,
	changes to split the FCXP memory allocation, support to register the
	node symbolic name with the name server, support for max target ports discovery
	and updates the Brocade BFA driver to v3.1.2.0.

	I have compiled and tested the code against your scsi-misc.

Thanks,
Krishna C Gudipati

Krishna Gudipati (10):
  bfa: Support vport symbolic name change from sysfs.
  bfa: FCS remote port enhancements.
  bfa: Make changes to FCXP resource management.
  bfa: Add new hardware model info to sysfs model description routine.
  bfa: Add PowerPC support and enable PCIE AER handling.
  bfa: Fix to process mbox interrupts only if interrupts are enabled in
    INTx mode.
  bfa: Add support to register node symbolic name with name server
  bfa: Add support for max target ports discovery
  bfa: Update MAINTAINERS file for BFA driver.
  bfa: Update the driver version to v3.1.2.0.

 MAINTAINERS                      |    1 -
 drivers/scsi/bfa/bfa_core.c      |   21 +-
 drivers/scsi/bfa/bfa_cs.h        |    4 +-
 drivers/scsi/bfa/bfa_defs_fcs.h  |   18 +
 drivers/scsi/bfa/bfa_fc.h        |   10 +
 drivers/scsi/bfa/bfa_fcbuild.c   |   21 ++
 drivers/scsi/bfa/bfa_fcbuild.h   |    2 +
 drivers/scsi/bfa/bfa_fcpim.c     |   12 +-
 drivers/scsi/bfa/bfa_fcs.c       |  182 +++++++++++-
 drivers/scsi/bfa/bfa_fcs.h       |   66 ++++-
 drivers/scsi/bfa/bfa_fcs_fcpim.c |  129 +++++----
 drivers/scsi/bfa/bfa_fcs_lport.c |  632 +++++++++++++++++++++++++++++++++++---
 drivers/scsi/bfa/bfa_fcs_rport.c |  466 +++++++++++++++++++++--------
 drivers/scsi/bfa/bfa_ioc.c       |   24 +-
 drivers/scsi/bfa/bfa_ioc.h       |    2 +
 drivers/scsi/bfa/bfa_modules.h   |    1 +
 drivers/scsi/bfa/bfa_svc.c       |   95 +++++--
 drivers/scsi/bfa/bfa_svc.h       |   23 +-
 drivers/scsi/bfa/bfad.c          |  236 ++++++++++++++-
 drivers/scsi/bfa/bfad_attr.c     |   46 +++-
 drivers/scsi/bfa/bfad_bsg.c      |   39 ++-
 drivers/scsi/bfa/bfad_bsg.h      |    2 +
 drivers/scsi/bfa/bfad_drv.h      |    5 +-
 drivers/scsi/bfa/bfad_im.c       |    9 +
 24 files changed, 1736 insertions(+), 310 deletions(-)

-- 
1.7.3.rc1

