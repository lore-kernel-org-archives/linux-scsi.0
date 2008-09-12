From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/8] qla2xxx: updates for 2.6.28 [8.02.01-k8].
Date: Thu, 11 Sep 2008 21:22:46 -0700
Message-ID: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46751 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYILEW5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2008 00:22:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Here's the first round of updates/fixes for 2.6.28:

Andrew Vasquez (5):
  qla2xxx: Change GFP_ATOMIC to GFP_KERNEL for non-atomic allocations.
  qla2xxx: Add Flash Layout Table support.
  qla2xxx: Add NPIV-Config Table support.
  qla2xxx: Additional residual-count corrections during UNDERRUN
    handling.
  qla2xxx: Update version number to 8.02.01-k8.

Bjorn Helgaas (1):
  qla2xxx: Fix "occured" spelling errors.

Harish Zunjarrao (1):
  qla2xxx: Add input/output byte-count statistics.

Ravi Anand (1):
  qla2xxx: Ignore payload reserved-bits during RSCN processing.

 drivers/scsi/qla2xxx/qla_attr.c    |    9 +-
 drivers/scsi/qla2xxx/qla_def.h     |   12 ++-
 drivers/scsi/qla2xxx/qla_fw.h      |   71 +++++++-
 drivers/scsi/qla2xxx/qla_gbl.h     |    4 +-
 drivers/scsi/qla2xxx/qla_init.c    |   14 +-
 drivers/scsi/qla2xxx/qla_inline.h  |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |   30 ++-
 drivers/scsi/qla2xxx/qla_isr.c     |   17 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |    6 +-
 drivers/scsi/qla2xxx/qla_os.c      |    9 +-
 drivers/scsi/qla2xxx/qla_sup.c     |  336 ++++++++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 12 files changed, 444 insertions(+), 68 deletions(-)

