From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/4] qla2xxx: small fixes for 2.6.18 [8.01.05-k4].
Date: Tue, 1 Aug 2006 13:45:42 -0700
Message-ID: <20060801204542.GR4154@jdlab1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:9867 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1750704AbWHAUpo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2006 16:45:44 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

This patchset updates the qla2xxx driver to 8.01.05-k4.

 drivers/scsi/qla2xxx/qla_def.h     |    1 +
 drivers/scsi/qla2xxx/qla_iocb.c    |    1 +
 drivers/scsi/qla2xxx/qla_isr.c     |    5 +++++
 drivers/scsi/qla2xxx/qla_os.c      |   12 +++---------
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 5 files changed, 11 insertions(+), 10 deletions(-)

here's the commits:

- Correct endianess problem while issuing a Marker IOCB on ISP24xx.
- Log Trace/Diagonostic asynchronous events.
- Fix to allow to reset devices using sg interface (sg_reset).
- Update version number to 8.01.05-k4.


Regards,
Andrew Vasquez
QLogic Corporation
