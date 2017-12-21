From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] Another round of SES fixes
Date: Thu, 21 Dec 2017 12:22:31 +0100
Message-ID: <1513855354-86603-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60779 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752089AbdLULWi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 06:22:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

I recently played around with a new NetApp E-series, and found some
issue with our SES implementation.

As usual, comments and reviews are welcome.

Hannes Reinecke (3):
  ses: make initial allocation size configurable
  ses: skip error messages for invalid LUNs
  ses: Retry Power-on-reset check condition

 drivers/scsi/ses.c | 47 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 13 deletions(-)

-- 
1.8.5.6
