From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/9] qla2xxx: fixes for 2.6.20 [8.01.07-k4].
Date: Wed, 13 Dec 2006 19:19:35 -0800
Message-ID: <20061214031935.GB538@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:39867 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbWLNDdt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Dec 2006 22:33:49 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@steeleye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

This patchset updates the qla2xxx driver to 8.01.07-k4.

 drivers/scsi/qla2xxx/qla_def.h     |    2 +
 drivers/scsi/qla2xxx/qla_gs.c      |   24 +++++++++++---
 drivers/scsi/qla2xxx/qla_init.c    |    8 +++--
 drivers/scsi/qla2xxx/qla_isr.c     |   15 +++++----
 drivers/scsi/qla2xxx/qla_mbx.c     |   12 ++++----
 drivers/scsi/qla2xxx/qla_os.c      |   59 +++++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 7 files changed, 73 insertions(+), 49 deletions(-)

here's the commits:

- Don't log trace-control async-events.
- Correct endianess issue while interrogating MS status.
- Use proper prep_ms_iocb() function during GFPN_ID.
- Detect GPSC capabilities within a fabric.
- Correct IOCB queuing mechanism for ISP54XX HBAs.
- Correct reset handling logic.
- Perform a fw-dump when an ISP23xx RISC-paused state is detected.
- Use generic isp_ops.fw_dump() function.
- Update version number to 8.01.07-k4.

Regards,
Andrew Vasquez
QLogic Corporation
