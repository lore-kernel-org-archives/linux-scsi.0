From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/5] [SCSI] scsi_dh_alua: fixes and new dev support
Date: Wed,  5 Jan 2011 16:00:19 -0500
Message-ID: <1294261224-12599-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab1AEVAe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 16:00:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>

James,

I'm sheparding these fixes and new dev support on behalf of Intel,
Promise and NetApp.  Please review and queue for 2.6.39 if you're OK
with the changes.

Thanks,
Mike

Ilgu Hong (1):
  scsi_dh_alua: Add Promise VTrak to dev list

Joseph Gruher (3):
  scsi_dh_alua: fix submit_stpg return
  scsi_dh_alua: fix deadlock in stpg_endio
  scsi_dh_alua: fix stpg_endio group state reporting

Mike Snitzer (1):
  scsi_dh_alua: add scalable ONTAP lun to dev list

 drivers/scsi/device_handler/scsi_dh_alua.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

-- 
1.7.3.4

