From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH RESEND 0/6] hpsa: support legacy boards
Date: Tue,  8 Aug 2017 10:35:09 +0200
Message-ID: <1502181315-102499-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51876 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750849AbdHHIfS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Aug 2017 04:35:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

(Resend to include linux-scsi)

Hi all,

this patch adds support for legacy boards, ie for boards previously
supported by cciss only.
With this patchset the hpsa driver should work with all Smart Array
boards if the 'hpsa_allow_any' module option is set, rendering the
cciss driver obsolete.

Hannes Reinecke (5):
  hpsa: consolidate status variables
  hpsa: add support for legacy boards
  hpsa: disable volume status check for older controller
  hpsa: Ignore errors for unsupported LV_DEVICE_ID VPD page
  hpsa: do not print errors for unsupported report luns format

Jeff Mahoney (1):
  hpsa: handle unsupported devices more gracefully

 drivers/scsi/hpsa.c | 131 ++++++++++++++++++++++++++++++++++++++++++++--------
 drivers/scsi/hpsa.h |  57 ++++++++++++++++++++---
 2 files changed, 162 insertions(+), 26 deletions(-)

-- 
1.8.5.6
