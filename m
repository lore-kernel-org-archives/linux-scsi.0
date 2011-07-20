From: <kgudipat@brocade.com>
Subject: [PATCH 00/15] bfa: Update the driver version to 3.0.2.2
Date: Wed, 20 Jul 2011 16:58:35 -0700
Message-ID: <1311206315-23195-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:55965 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664Ab1GTX7P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2011 19:59:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Hi James,

	The following patch set enhances support for Brocade-1860 Fabric Adapter
	and updates the Brocade BFA driver to v3.0.2.2.

	The patch-set adds FC-transport based AEN support, extends BSG interface
	to support more user commands and adds Initiator based lun masking feature.

	I have compiled & tested the code against your scsi-misc and
	linux-next (3.0.0-rc7-0.7-default).

Thanks,
Krishna C Gudipati.

Krishna Gudipati (15):
  bfa: Add FC-transport based Asynchronous Event Notification support.
  bfa: BSG return value fix to be compatible with kernel convention.
  bfa: Update RME interrupt handling.
  bfa: Check supported speed based on port mode
  bfa: Extend BSG to support more user commands
  bfa: Add support for IO profiling.
  bfa: Added support to collect and reset fcport stats
  bfa: Add support to configure and query flash boot partition
  bfa: Add support to configure trunking on Brocade adapter ports.
  bfa: Added support to configure QOS and collect stats.
  bfa: Add support to collect fabric stats.
  bfa: Add support to store driver configuration in flash.
  bfa: Introduced initiator based lun masking feature.
  bfa: Added support to configure lunmasking
  bfa: Update the driver version to 3.0.2.2

 drivers/scsi/bfa/bfa.h           |   51 ++-
 drivers/scsi/bfa/bfa_core.c      |   60 ++-
 drivers/scsi/bfa/bfa_defs.h      |  171 ++++++
 drivers/scsi/bfa/bfa_defs_svc.h  |   99 ++++
 drivers/scsi/bfa/bfa_fc.h        |  155 ++++++
 drivers/scsi/bfa/bfa_fcpim.c     |  736 ++++++++++++++++++++++++++-
 drivers/scsi/bfa/bfa_fcpim.h     |   45 ++-
 drivers/scsi/bfa/bfa_fcs.c       |   26 +
 drivers/scsi/bfa/bfa_fcs.h       |    1 +
 drivers/scsi/bfa/bfa_fcs_fcpim.c |   37 ++-
 drivers/scsi/bfa/bfa_fcs_lport.c |   74 +++-
 drivers/scsi/bfa/bfa_fcs_rport.c |   49 ++-
 drivers/scsi/bfa/bfa_hw_cb.c     |   38 ++-
 drivers/scsi/bfa/bfa_hw_ct.c     |   25 +-
 drivers/scsi/bfa/bfa_ioc.c       |  569 ++++++++++++++++++++-
 drivers/scsi/bfa/bfa_ioc.h       |   48 ++-
 drivers/scsi/bfa/bfa_modules.h   |    3 +
 drivers/scsi/bfa/bfa_svc.c       |  249 +++++++---
 drivers/scsi/bfa/bfa_svc.h       |   29 +-
 drivers/scsi/bfa/bfad.c          |    8 +-
 drivers/scsi/bfa/bfad_bsg.c      | 1084 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/bfa/bfad_bsg.h      |  237 +++++++++
 drivers/scsi/bfa/bfad_drv.h      |    6 +-
 drivers/scsi/bfa/bfad_im.c       |   26 +
 drivers/scsi/bfa/bfad_im.h       |   22 +
 drivers/scsi/bfa/bfi.h           |   20 +
 26 files changed, 3724 insertions(+), 144 deletions(-)

-- 
1.7.3.rc1

