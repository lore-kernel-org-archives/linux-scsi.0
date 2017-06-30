From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] Drop legacy megaraid implementation
Date: Fri, 30 Jun 2017 13:05:52 +0200
Message-ID: <1498820754-51032-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48338 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751878AbdF3LGC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 07:06:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The legacy megaraid implementation is ancient, and support for most boards
has been moved to megaraid_mm anyway. So drop the legacy implementation.
And do not refer to 'megaraid_mm' as a 'new driver'; it's close to be obsoleted
itself.

Hannes Reinecke (2):
  Drop legacy megaraid controller
  megaraid: drop the 'new driver' statements

 MAINTAINERS                            |    1 -
 drivers/scsi/Makefile                  |    1 -
 drivers/scsi/megaraid.c                | 4730 --------------------------------
 drivers/scsi/megaraid.h                | 1010 -------
 drivers/scsi/megaraid/Kconfig.megaraid |   17 +-
 5 files changed, 3 insertions(+), 5756 deletions(-)
 delete mode 100644 drivers/scsi/megaraid.c
 delete mode 100644 drivers/scsi/megaraid.h

-- 
1.8.5.6
