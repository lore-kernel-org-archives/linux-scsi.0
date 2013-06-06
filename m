From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/3] scsi: More detailed I/O errors
Date: Thu,  6 Jun 2013 10:26:04 +0200
Message-ID: <1370507167-35998-1-git-send-email-hare@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Theodore T'so <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

As discussed at LSF the SCSI stack already knows about several
error conditions, it's just not well documented.
Also there are some more conditions upper layers might be
interested in.

This patchset improves the documentation of the existing
I/O error codes and adds two more error codes, ENOSPC
for thin provisioning failure and ENODATA for medium error.

Changes since the initial version, suggested by Ren Mingxin:
- Add error description to blk_update_request()
- Document missing values

Hannes Reinecke (3):
  scsi: Document enhanced error codes
  scsi: Return ENOSPC on thin provisioning failure
  scsi: Return ENODATA on medium error

 block/blk-core.c          |  6 ++++++
 drivers/scsi/scsi_error.c | 27 +++++++++++++++++++++++----
 drivers/scsi/scsi_lib.c   | 22 ++++++++++++++++++++++
 include/scsi/scsi.h       |  4 ++++
 4 files changed, 55 insertions(+), 4 deletions(-)

-- 
1.7.12.4

