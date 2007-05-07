From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/6] qla2xxx: updates for 2.6.22 [8.01.07-k7].
Date: Mon, 7 May 2007 07:42:16 -0700
Message-ID: <20070507144216.GC7207@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47025 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934086AbXEGOma (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 10:42:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@steeleye.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

This patchset updates the qla2xxx driver to 8.01.07-k7.

 drivers/scsi/qla2xxx/qla_init.c    |   33 ++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_isr.c     |   15 ++++++++++++++-
 drivers/scsi/qla2xxx/qla_os.c      |    6 ++----
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 4 files changed, 33 insertions(+), 23 deletions(-)

here's the commits:

- Error-out during probe() if we're unable to complete HBA initialization.
- Honor NVRAM port-down-retry-count settings.
- Attempt to stop firmware only if it had been previously executed.
- Correct pci_set_msi() usage semantics.
- Add MSI support.
- Update version number to 8.01.07-k7.

Regards,
Andrew Vasquez
QLogic Corporation
