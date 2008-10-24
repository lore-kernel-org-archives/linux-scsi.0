From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/5] qla2xxx: fixes for 2.6.28 [8.02.01-k9].
Date: Fri, 24 Oct 2008 15:13:43 -0700
Message-ID: <1224886428-31799-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:14169 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbYJXWNt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2008 18:13:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Here's another round of fixes for 2.6.28.

Andrew Vasquez (2):
  qla2xxx: Use pci_disable_rom() to manipulate PCI config space.
  qla2xxx: Update version number to 8.02.01-k9.

Lalit Chandivade (1):
  qla2xxx: Correct Atmel flash-part handling.

Michael Reed (1):
  qla2xxx: Return a FAILED status when abort mailbox-command fails.

Shyam Sundar (1):
  qla2xxx: Do not honour max_vports from firmware for 2G ISPs and
    below.

 drivers/scsi/qla2xxx/qla_def.h     |    1 -
 drivers/scsi/qla2xxx/qla_init.c    |   26 +++++---------------------
 drivers/scsi/qla2xxx/qla_mbx.c     |    2 +-
 drivers/scsi/qla2xxx/qla_os.c      |    1 +
 drivers/scsi/qla2xxx/qla_sup.c     |   19 +++++++------------
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 6 files changed, 15 insertions(+), 36 deletions(-)
