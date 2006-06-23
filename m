From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/13] qla2xxx: driver update [8.01.05-k3].
Date: Fri, 23 Jun 2006 16:08:15 -0700
Message-ID: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:56745 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1752152AbWFWXJS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 19:09:18 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

This patchset updates the qla2xxx driver to 8.01.05-k3.

 drivers/scsi/qla2xxx/qla_attr.c    |  120 +++--
 drivers/scsi/qla2xxx/qla_dbg.c     |  925 +++++++-----------------------------
 drivers/scsi/qla2xxx/qla_dbg.h     |  151 +++---
 drivers/scsi/qla2xxx/qla_def.h     |   19 +
 drivers/scsi/qla2xxx/qla_devtbl.h  |   17 +
 drivers/scsi/qla2xxx/qla_fw.h      |    4
 drivers/scsi/qla2xxx/qla_gbl.h     |   20 -
 drivers/scsi/qla2xxx/qla_init.c    |  135 ++++-
 drivers/scsi/qla2xxx/qla_isr.c     |   24 -
 drivers/scsi/qla2xxx/qla_mbx.c     |  280 +++++++----
 drivers/scsi/qla2xxx/qla_os.c      |  121 ++---
 drivers/scsi/qla2xxx/qla_version.h |    2
 12 files changed, 726 insertions(+), 1092 deletions(-)

here's the commits:

- Rework firmware-trace facilities.
- Resync with latest HBA SSID specification -- 2.2j.
- Add NVRAM 'Disable Serdes' bit support.
- Honour 'skip process-login' option during fabric-login IOCB.
- Add DMI (Diagnostics Monitoring Interface) support.
- Create an VPD sysfs entry for supported ISPs only.
- Remove no-op IOCTL codes and macros.
- Cleanup DEBUG macro usage.
- Add support for extended error logging.
- Correct 'loop-down' determination logic in qla2x00_fw_ready().
- Convert from pci_module_init() to pci_register_driver().
- Correctly set the firmware NOS/OLS timeout during initialization.
- Update version number to 8.01.05-k3.


Regards,
Andrew Vasquez
QLogic Corporation
