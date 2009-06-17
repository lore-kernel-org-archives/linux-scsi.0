From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/5] qla2xxx: fixes for 2.6.31. [8.03.01-k4]
Date: Wed, 17 Jun 2009 10:30:27 -0700
Message-ID: <1245259832-8595-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:16588 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759868AbZFQRaa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2009 13:30:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Please apply...

--

Andrew Vasquez (3):
  qla2xxx: Limit querying to supported mailbox-registers while reading
    FW state.
  qla2xxx: Correct (again) overflow during dump-processing on
    large-memory ISP23xx parts.
  qla2xxx: Update version number to 8.03.01-k4.

Anirban Chakraborty (1):
  qla2xxx: Fixed a bug in number of response queue creation logic.

Harish Zunjarrao (1):
  qla2xxx: Correct iiDMA-update calling conventions.

 drivers/scsi/qla2xxx/qla_dbg.c     |    2 +-
 drivers/scsi/qla2xxx/qla_init.c    |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |   28 +++++++++++++++++-----------
 drivers/scsi/qla2xxx/qla_os.c      |    2 +-
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 5 files changed, 21 insertions(+), 15 deletions(-)

