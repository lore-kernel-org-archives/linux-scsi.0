From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/5] Add support for ZBC host-managed devices
Date: Tue, 19 Jul 2016 15:25:05 +0200
Message-ID: <1468934710-93876-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbcGSNZN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 09:25:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.de>

Hi James,

this patchset adds support for ZBC host-managed devices to sd.
Support for it is selected with the new 'SCSI_ZBC' config option.

Patch has been made over Tejuns 'libata/for-4.8' repository.
It relies on the patchset "Support for zoned block devices" posted
earlier.

As usual, comments and reviews are welcome.

Damien Le Moal (2):
  sd: Limit messages for ZBC disks capacity change
  sd_zbc: Fix handling of ZBC read after write pointer

Hannes Reinecke (3):
  sd: configure ZBC devices
  sd: Implement new RESET_WP provisioning mode
  sd: Implement support for ZBC devices

 drivers/scsi/Kconfig      |   8 +
 drivers/scsi/Makefile     |   1 +
 drivers/scsi/sd.c         | 201 +++++++++++++++--
 drivers/scsi/sd.h         |  67 ++++++
 drivers/scsi/sd_zbc.c     | 559 ++++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_proto.h |  17 ++
 6 files changed, 832 insertions(+), 21 deletions(-)
 create mode 100644 drivers/scsi/sd_zbc.c

-- 
1.8.5.6

