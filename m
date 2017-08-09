From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/4] Fixup blacklist handling
Date: Wed,  9 Aug 2017 12:44:00 +0200
Message-ID: <1502275444-27676-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37849 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751972AbdHIKoP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 06:44:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Doug Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>

Hi all,

the SCSI blacklist handling seems to be rather tricky issue;
everytime a fix is included it tends to break other devices.
This patchset attempt to simplify the devlist handling yet again,
but this time implementing the framework for regression testing, too.
A patch adding a regression test to the blktest suite will follow.

As usual, comments and reviews are welcome.

Changes to v1:
- Implement exact match for vendor string as suggested by Bart
- Straigten out issues pointed out by Alan Stern
- Reshuffle patches

Hannes Reinecke (4):
  scsi_debug: allow to specify inquiry vendor and model
  scsi: Export blacklist flags to sysfs
  scsi: whitespace fixes in scsi_devinfo.c
  scsi_devinfo: fixup string compare

 drivers/scsi/scsi_debug.c   | 25 +++++++++-----
 drivers/scsi/scsi_devinfo.c | 84 ++++++++++++++++++++++++++++-----------------
 drivers/scsi/scsi_scan.c    |  1 +
 drivers/scsi/scsi_sysfs.c   | 11 ++++++
 4 files changed, 81 insertions(+), 40 deletions(-)

-- 
1.8.5.6
