From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 00/20] qla2xxx: Updates for 2.6.31 merge-window [8.03.01-k3]
Date: Wed,  3 Jun 2009 09:55:11 -0700
Message-ID: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbZFCQzb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Another round of updates/fixes for 2.6.31.

 drivers/scsi/qla2xxx/qla_attr.c    |  166 +++++++++++++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_dbg.c     |    6 +-
 drivers/scsi/qla2xxx/qla_def.h     |   13 +++-
 drivers/scsi/qla2xxx/qla_fw.h      |    4 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   14 +++-
 drivers/scsi/qla2xxx/qla_gs.c      |    3 +
 drivers/scsi/qla2xxx/qla_init.c    |  120 +++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_iocb.c    |   16 ++--
 drivers/scsi/qla2xxx/qla_isr.c     |    4 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |  154 ++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_os.c      |   61 ++++++++-----
 drivers/scsi/qla2xxx/qla_sup.c     |   11 ++-
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 13 files changed, 490 insertions(+), 84 deletions(-)

Here's the commits:

Andrew Vasquez (18):
  qla2xxx: Export negotiated fabric-parameters for application support.
  qla2xxx: Export XGMAC statistics on supported ISPs.
  qla2xxx: Export TLV data on supported ISPs.
  qla2xxx: Correct logic-bug in set-model-info().
  qla2xxx: Fallback to 'golden-firmware' operation on supported ISPs.
  qla2xxx: Use 'proper' DID_* status code for dropped-frame scenarios.
  qla2xxx: Check status of qla2x00_get_fw_version() call.
  qla2xxx: Mark a port's state as needing-rediscovery during link
    disruptions.
  qla2xxx: Add 10Gb iiDMA support.
  qla2xxx: Add notification message when an NPIV fails to acquire a
    port-id.
  qla2xxx: Fallback enode-mac should not be a multicast address.
  qla2xxx: Avoid redundant RISC reset during (re)-initialization.
  qla2xxx: Query supported RISC registers bits in determining a
    paused-state.
  qla2xxx: Avoid explicit LOGO during driver host tear-down.
  qla2xxx: Reduce lock-contention during do-work processing.
  qla2xxx: Export additional firmware-states for application support.
  qla2xxx: Synchronize MPI settings after a PE Reset.
  qla2xxx: Update version number to 8.03.01-k3.

Anirban Chakraborty (2):
  qla2xxx: Correct queue-creation bug when driver loaded in QoS mode.
  qla2xxx: Correct NULL pointer bug in cpu affinity mode.
