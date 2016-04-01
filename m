From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] scsi: vpd sanity checks
Date: Fri,  1 Apr 2016 08:57:35 +0200
Message-ID: <1459493857-4724-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbcDAG5l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 02:57:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's a combined patchset to clear up the sanity checks for VPD page
support. The first patch streamlines the function to check for VPD page
support, and the second one lowers the minimal SCSI version for VPD
page support to SPC-2, to avoid having to whitelist a lot of devices.

As usual, comments and reviews are welcome.

Hannes Reinecke (2):
  scsi: Do not attach VPD to devices that don't support it
  scsi: vpd pages are mandatory for SPC-2

 drivers/scsi/scsi.c        |  3 ++-
 drivers/scsi/sd.c          | 19 +------------------
 include/scsi/scsi_device.h | 25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 19 deletions(-)

-- 
2.6.2

