From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] scsi: More detailed I/O errors
Date: Wed,  5 Jun 2013 09:10:58 +0200
Message-ID: <1370416261-57005-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab3FEHLF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jun 2013 03:11:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Theodore T'so <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>

As discussed at LSF the SCSI stack already knows about several
error conditions, it's just not well documented.
Also there are some more conditions upper layers might be
interested in.

This patchset improves the documentation of the existing
I/O error codes and adds two more error codes, ENOSPC
for thin provisioning failure and ENODATA for medium error.

Hannes Reinecke (3):
  scsi: Document enhanced error codes
  scsi: Return ENOSPC on thin provisioning failure
  scsi: Return ENODATA on medium error

 drivers/scsi/scsi_error.c | 26 ++++++++++++++++++++++----
 drivers/scsi/scsi_lib.c   | 21 +++++++++++++++++++++
 include/scsi/scsi.h       |  4 ++++
 3 files changed, 47 insertions(+), 4 deletions(-)

-- 
1.7.12.4

