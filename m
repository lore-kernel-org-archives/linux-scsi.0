From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/6] qla2xxx: fixes for 2.6.21 [8.01.07-k6].
Date: Mon, 12 Mar 2007 10:40:19 -0700
Message-ID: <20070312174019.GA1216@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:25227 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbXCLRkV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Mar 2007 13:40:21 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@steeleye.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

This patchset updates the qla2xxx driver to 8.01.07-k6.

 drivers/scsi/qla2xxx/qla_def.h     |   13 ++++++++-----
 drivers/scsi/qla2xxx/qla_os.c      |    4 +++-
 drivers/scsi/qla2xxx/qla_sup.c     |   11 +++++------
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 4 files changed, 17 insertions(+), 13 deletions(-)

here's the commits:

- fix RSCN handling on big-endian systems
- Add scan_[start|finish]() callbacks for ISP24xx HBAs.
- Add cond_resched() calls during HBA flash manipulation.
- Drop acquisition of hardware_lock during flash manipulations.
- Allow the extended-error-logging flag to be dynamic.
- Update version number to 8.01.07-k6.

Regards,
Andrew Vasquez
QLogic Corporation
