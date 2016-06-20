From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] VPD page check consolidation
Date: Mon, 20 Jun 2016 08:57:45 +0200
Message-ID: <1466405868-87720-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbcFTHdw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2016 03:33:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

as per recent discussion this patchset consolidates the
VPD page checks. With it VPD page scan will be disabled
if the initial scan encounters an error, and also the
checks for VPD pages are consolidated in the function
scsi_device_supports_vpd().

As usual, comments and reviews are welcome.

Hannes Reinecke (3):
  scsi: Move 'scsi_attach_vpd()' prototype to scsi_priv.h
  scsi: disable VPD page check on error
  scsi: consolidate checking for VPD pages

 drivers/scsi/scsi.c               | 14 ++++++++++----
 drivers/scsi/scsi_priv.h          |  1 +
 drivers/scsi/scsi_scan.c          |  4 ++--
 drivers/scsi/scsi_transport_sas.c |  3 ++-
 include/scsi/scsi_device.h        |  1 -
 5 files changed, 15 insertions(+), 8 deletions(-)

-- 
1.8.5.6

