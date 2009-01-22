From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 00/12] qla2xxx: fixes for 2.6.29-rcX [8.03.00-k2].
Date: Thu, 22 Jan 2009 09:45:27 -0800
Message-ID: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46489 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265AbZAVRpn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 12:45:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Here's another round of fixes for 2.6.29.


Andrew Vasquez (8):
  qla2xxx: Simplify sector-mask calculation in preparation for larger
    flash parts.
  qla2xxx: Ensure RISC-interrupt-enabled consistency for
    IS_NOPOLLING_TYPE() ISPs.
  qla2xxx: Always serialize mailbox command execution.
  qla2xxx: Modify firmware-load order precedence for ISP81XX parts.
  qla2xxx: Correct endianness issue during flash manipulation.
  qla2xxx: Correct regression in EH abort handling.
  qla2xxx: Correct regression in DMA-mask setting prior to allocations.
  qla2xxx: Update version number to 8.03.00-k2.

Anirban Chakraborty (1):
  qla2xxx: Fix memory leak in error path

Joe Carnuccio (1):
  qla2xxx: Correct descriptions in flash manipulation routines.

Lalit Chandivade (1):
  qla2xxx: Correct MSI-X vector allocation for single queue mode.

Seokmann Ju (1):
  qla2xxx: Add checks for a valid fcport in
    dev-loss-tmo/terminate_rport_io callbacks.

 drivers/scsi/qla2xxx/qla_attr.c    |    6 ++++
 drivers/scsi/qla2xxx/qla_gbl.h     |    1 +
 drivers/scsi/qla2xxx/qla_init.c    |   53 +++++++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_isr.c     |    5 +++
 drivers/scsi/qla2xxx/qla_mbx.c     |   16 ++++-------
 drivers/scsi/qla2xxx/qla_os.c      |   22 ++++++++-------
 drivers/scsi/qla2xxx/qla_sup.c     |   23 ++++++---------
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 8 files changed, 87 insertions(+), 41 deletions(-)
