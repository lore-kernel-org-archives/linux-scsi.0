From: <kgudipat@brocade.com>
Subject: [PATCH 00/15] bfa: Update the driver version to 3.1.2.1
Date: Fri, 21 Sep 2012 17:23:55 -0700
Message-ID: <1348273435-26498-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:51680 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029Ab2IVAYD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Sep 2012 20:24:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Hi James,

	The following patch-set includes bug-fixes, firmware naming convention change,
	adds new features such as FC Arbitrated Loop support, Diagnostic Port (D-port),
	IO throttle, FRU update support, QoS bandwidth config support to the BFA driver
	and updates the Brocade BFA driver to v3.1.2.1.

	I have compiled and tested the code against your scsi-misc.

Thanks,
Krishna C Gudipati

Krishna Gudipati (15):
  bfa: Add support for FC Arbitrated Loop topology.
  bfa: IOCFC state machine enhancements
  bfa: Flash Controller PLL initialization fixes
  bfa: Add support to have mfg date as part of adapter attributes
  bfa: Fix few attributes in the RHBA CT passthru command
  bfa: Fix to handle firmware tskim abort request response
  bfa: Add diagnostic port (D-Port) support
  bfa: Fabric Assigned Address implementation fix
  bfa: Add support for user to configure bandwidth on QoS priorities
  bfa: Add support for IO throttling at port level
  bfa: Add support to configure min/max bandwidth for a pcifn
  bfa: Support Power on Hours display and diag temp sensor fixes
  bfa: Add support to read/update the FRU data.
  bfa: Firmware image naming convention update
  bfa: Update the driver version to 3.1.2.1

 drivers/scsi/bfa/bfa_core.c      |   85 ++++-
 drivers/scsi/bfa/bfa_defs.h      |   61 +++-
 drivers/scsi/bfa/bfa_defs_svc.h  |  119 +++++-
 drivers/scsi/bfa/bfa_fc.h        |    5 +
 drivers/scsi/bfa/bfa_fcbuild.c   |    4 +
 drivers/scsi/bfa/bfa_fcpim.c     |  123 ++++++-
 drivers/scsi/bfa/bfa_fcpim.h     |   13 +-
 drivers/scsi/bfa/bfa_fcs.c       |   64 +++-
 drivers/scsi/bfa/bfa_fcs.h       |   23 +-
 drivers/scsi/bfa/bfa_fcs_lport.c |  155 ++++++++-
 drivers/scsi/bfa/bfa_fcs_rport.c |  288 +++++++++++++--
 drivers/scsi/bfa/bfa_ioc.c       |  494 ++++++++++++++++++++++++-
 drivers/scsi/bfa/bfa_ioc.h       |   63 +++-
 drivers/scsi/bfa/bfa_ioc_ct.c    |  236 +++++++------
 drivers/scsi/bfa/bfa_modules.h   |    1 +
 drivers/scsi/bfa/bfa_port.c      |   32 ++
 drivers/scsi/bfa/bfa_port.h      |    3 +
 drivers/scsi/bfa/bfa_svc.c       |  732 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/bfa/bfa_svc.h       |   30 ++-
 drivers/scsi/bfa/bfad.c          |    6 +-
 drivers/scsi/bfa/bfad_bsg.c      |  373 +++++++++++++++++---
 drivers/scsi/bfa/bfad_bsg.h      |   63 ++++-
 drivers/scsi/bfa/bfad_drv.h      |    2 +-
 drivers/scsi/bfa/bfi.h           |   72 ++++-
 drivers/scsi/bfa/bfi_ms.h        |   14 +
 drivers/scsi/bfa/bfi_reg.h       |    3 +
 26 files changed, 2762 insertions(+), 302 deletions(-)

-- 
1.7.3.rc1

