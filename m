From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 0/5] Hi all,
Date: Fri, 11 Aug 2017 16:23:16 +0200
Message-ID: <1502461401-94630-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34109 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752730AbdHKOXZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Aug 2017 10:23:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

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

Changes to v2:
- Simplify code as indicated by Alan Stern
- Display blacklist flags verbatim
- Reformat blacklist flags definition for better readability

Hannes Reinecke (5):
  scsi_debug: allow to specify inquiry vendor and model
  scsi: Export blacklist flags to sysfs
  scsi_devinfo: Reformat blacklist flags
  scsi: whitespace fixes in scsi_devinfo.c
  scsi_devinfo: fixup string compare

 drivers/scsi/scsi_debug.c   | 25 +++++++++-----
 drivers/scsi/scsi_devinfo.c | 67 +++++++++++++++++++-----------------
 drivers/scsi/scsi_scan.c    |  1 +
 drivers/scsi/scsi_sysfs.c   | 83 +++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_devinfo.h | 77 +++++++++++++++++++++++++++--------------
 5 files changed, 187 insertions(+), 66 deletions(-)

-- 
1.8.5.6
