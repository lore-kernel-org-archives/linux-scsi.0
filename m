From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] scsi trace updates
Date: Thu, 24 Mar 2016 11:23:28 +0100
Message-ID: <1458815011-9054-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362AbcCXKXg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Mar 2016 06:23:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here are some some small updates to scsi tracing; it fixes the
decoding for MAINTENANCE_IN and MAINTENANCE_OUT and adds definitions
for the new ZBC_IN and ZBC_OUT commands.

As usual, comments and reviews welcome.

Hannes Reinecke (3):
  scsi-trace: remove service action definitions
  scsi-trace: Decode MAINTENANCE_IN and MAINTENANCE_OUT commands
  scsi-trace: define ZBC_IN and ZBC_OUT

 drivers/scsi/scsi_trace.c   | 183 ++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_proto.h   |   9 +++
 include/trace/events/scsi.h |   6 +-
 3 files changed, 194 insertions(+), 4 deletions(-)

-- 
1.8.5.6

