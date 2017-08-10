From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] scsi: pollable 'state' attribute
Date: Thu, 10 Aug 2017 09:05:28 +0200
Message-ID: <1502348731-63534-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41444 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752282AbdHJHFg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 03:05:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's a small patchset to make the 'state' device attribute pollable.
It was supposed to be a small patch, but tnen hch suggested a rework
and I found a missing state transition.

So there you go.

Hannes Reinecke (3):
  scsi: allow state transition CREATED_BLOCK -> TRANSPORT_OFFLINE
  scsi_lib: rework scsi_internal_device_unblock_nowait()
  scsi: make 'state' device attribute pollable

 drivers/scsi/scsi_lib.c           | 22 ++++++++++++++++------
 drivers/scsi/scsi_transport_srp.c |  5 ++++-
 2 files changed, 20 insertions(+), 7 deletions(-)

-- 
1.8.5.6
