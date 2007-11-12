From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/4] qla2xxx: fixes for 2.6.24 [8.02.00-k6].
Date: Mon, 12 Nov 2007 10:29:50 -0800
Message-ID: <20071112182950.GC20765@plap3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:33007 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbXKLSaM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Nov 2007 13:30:12 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

This patchset contains fixes for 2.6.24.

 drivers/scsi/qla2xxx/qla_attr.c    |    2 +-
 drivers/scsi/qla2xxx/qla_def.h     |   10 +---------
 drivers/scsi/qla2xxx/qla_fw.h      |   16 ++++++++++------
 drivers/scsi/qla2xxx/qla_init.c    |   19 +++++++------------
 drivers/scsi/qla2xxx/qla_isr.c     |   11 +++++------
 drivers/scsi/qla2xxx/qla_mbx.c     |    4 ++--
 drivers/scsi/qla2xxx/qla_mid.c     |   33 ++++++++++++---------------------
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 8 files changed, 39 insertions(+), 58 deletions(-)

here's the commits:

- Don't explicitly read mbx registers while processing a system-error.
- Correct NPIV support for recent ISPs.
- Properly handle Vport state-change-notifications.
- Update version number to 8.02.00-k6.

Regards,
Andrew Vasquez
QLogic Corporation
