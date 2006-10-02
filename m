From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/8] qla2xxx: driver update.
Date: Mon, 2 Oct 2006 11:59:47 -0700
Message-ID: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:30298 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S964908AbWJBS7t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 14:59:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

This patchset updates the qla2xxx driver to 8.01.07-k2.

 drivers/scsi/qla2xxx/qla_attr.c    |   57 +++++++++-
 drivers/scsi/qla2xxx/qla_def.h     |   40 ++++++-
 drivers/scsi/qla2xxx/qla_gbl.h     |    9 ++
 drivers/scsi/qla2xxx/qla_gs.c      |  228 +++++++++++++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_init.c    |   84 +++++++++++++-
 drivers/scsi/qla2xxx/qla_isr.c     |    4 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |   86 ++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c      |   48 +++++++-
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 9 files changed, 524 insertions(+), 34 deletions(-)

here's the commits:

 - Add iIDMA support.
 - Add support for symbolic nodename FC transport attribute.
 - Add support for system hostname FC transport attribute.
 - Add support for fabric name FC transport attribute.
 - Add support for host port state FC transport attribute.
 - Add MODULE_FIRMWARE tags.
 - Stall mid-layer error handlers while rport is blocked.
 - Update version number to 8.01.07-k2.
