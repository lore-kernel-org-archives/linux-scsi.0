From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/7] aacraid: split off EH functions
Date: Fri, 30 Jun 2017 19:18:05 +0200
Message-ID: <1498843092-76285-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59900 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751668AbdF3RTi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 13:19:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Hannes Reinecke <hare@suse.de>

Hi all,

this patchset is a split off from the original patchset to rework
SCSI EH function parameters. As it's pretty much independent and
an improvement to the existing EH callback function, so I'm posting
it separately.

As usual, comments and reviews are welcome.

Hannes Reinecke (7):
  aacraid: split off functions to generate reset FIB
  aacraid: split off host reset
  aacraid: split off device, target, and bus reset
  aacraid: use aac_tmf_callback for reset fib
  aacraid: enable sending of TMFs from aac_hba_send()
  aacraid: add fib flag to mark scsi command callback
  aacraid: complete all commands during bus reset

 drivers/scsi/aacraid/aacraid.h |   1 +
 drivers/scsi/aacraid/commsup.c |   3 +-
 drivers/scsi/aacraid/linit.c   | 318 ++++++++++++++++++++++++++++++-----------
 3 files changed, 235 insertions(+), 87 deletions(-)

-- 
1.8.5.6
