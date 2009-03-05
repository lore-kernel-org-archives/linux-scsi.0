From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/6] qla2xxx: fixes for 2.6.29-rcX.
Date: Thu,  5 Mar 2009 11:06:59 -0800
Message-ID: <1236280025-89526-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:5602 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZCETHI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2009 14:07:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Please apply...

---

Andrew Vasquez (4):
  qla2xxx: Correct address range checking for option-rom updates.
  qla2xxx: Correct truncation in return-code status checking.
  qla2xxx: Correct overwrite of pre-assigned init-control-block
    structure size.
  qla2xxx: Update version number to 8.03.00-k4.

Anirban Chakraborty (1):
  qla2xxx: Correct vport delete bug.

Lalit Chandivade (1):
  qla2xxx: Use correct value for max vport in LOOP topology.

 drivers/scsi/qla2xxx/qla_attr.c    |    9 +--------
 drivers/scsi/qla2xxx/qla_init.c    |   19 +++++++++++++------
 drivers/scsi/qla2xxx/qla_mbx.c     |    3 ++-
 drivers/scsi/qla2xxx/qla_mid.c     |   10 ++++++----
 drivers/scsi/qla2xxx/qla_os.c      |    6 +-----
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 6 files changed, 24 insertions(+), 25 deletions(-)

