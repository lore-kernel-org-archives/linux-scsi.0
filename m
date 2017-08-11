From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/2] scsi: pollable 'state' attribute
Date: Fri, 11 Aug 2017 08:53:45 +0200
Message-ID: <1502434427-101729-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51552 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751359AbdHKGxu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Aug 2017 02:53:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's a small patchset to make the 'state' device attribute pollable.
It was supposed to be a small patch, but then hch suggested a rework.

So there you go.

Changes to v2:
- Removed duplicate case value found by kbuild robot
- Dropped state update patch

Hannes Reinecke (2):
  scsi_lib: rework scsi_internal_device_unblock_nowait()
  scsi: make 'state' device attribute pollable

 drivers/scsi/scsi_lib.c           | 20 ++++++++++++++------
 drivers/scsi/scsi_transport_srp.c |  5 ++++-
 2 files changed, 18 insertions(+), 7 deletions(-)

-- 
1.8.5.6
