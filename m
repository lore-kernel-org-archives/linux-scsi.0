From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/8] qla2xxx: updates/fixes for 2.6.27-rc3 [8.02.01-k7].
Date: Wed, 13 Aug 2008 21:36:32 -0700
Message-ID: <20080814043632.GL61889@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:57933 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYHNEgd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2008 00:36:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

Another round of updates/fixes for 2.6.27-rc3.

 drivers/scsi/qla2xxx/qla_attr.c    |   11 +++++++++++
 drivers/scsi/qla2xxx/qla_def.h     |    2 +-
 drivers/scsi/qla2xxx/qla_init.c    |    8 ++++++--
 drivers/scsi/qla2xxx/qla_isr.c     |   14 +++++++-------
 drivers/scsi/qla2xxx/qla_mbx.c     |    2 +-
 drivers/scsi/qla2xxx/qla_os.c      |   18 ++++++++++++------
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 7 files changed, 39 insertions(+), 18 deletions(-)

here's the commits:

* Remove semaphore.h
* Correct synchronization of software/firmware fcport states.
* Correct vport-state management issues during ISP-ABORT.
* Don't leak SG-DMA mappings while aborting commands.
* Set npiv_supported flag for FCoE HBAs.
* Reference proper ha during SBR handling.
* Explicitly tear-down vports during PCI remove_one().
* Update version number to 8.02.01-k7.

Thanks, AV
