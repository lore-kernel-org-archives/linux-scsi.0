From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] sg: fix infoleak when using SG_GET_REQUEST_TABLE
Date: Fri, 15 Sep 2017 14:05:14 +0200
Message-ID: <1505477116-75013-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49365 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751248AbdIOMFY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Sep 2017 08:05:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alexander Potapenko <glider@google.com>, Ingo Molnar <mingo@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, security@kernel.org, Hannes Reinecke <hare@suse.de>

KMSAN detected a possible infoleak when using SG_GET_REQUEST_TABLE ioctl.
This patchset fixes it.

As usual, comments and reviews are welcome.

Hannes Reinecke (2):
  sg: factor out sg_fill_request_table()
  sg: fixup infoleak when using SG_GET_REQUEST_TABLE

 drivers/scsi/sg.c | 65 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 28 deletions(-)

-- 
1.8.5.6
