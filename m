From: Mike Snitzer <snitzer@redhat.com>
Subject: [RESEND PATCH 0/3] multipath features for 3.6
Date: Tue, 26 Jun 2012 14:32:02 -0400
Message-ID: <1340735525-21083-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371Ab2FZScR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jun 2012 14:32:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com

Hi James,

This scsi_dh patch is a prerequisite for the corresponding dm-multipath patch.
This scsi_dh patch has seen wide review and testing -- please apply it
for the 3.6 merge.  Alasdair will stage the dm-multipath changes for 3.6.

Thanks,
Mike

Hannes Reinecke (1):
  dm mpath: add ability to disable partition creation

Mike Snitzer (2):
  scsi_dh: add scsi_dh_attached_handler_name
  dm mpath: add 'default_hw_handler' feature

 drivers/md/dm-mpath.c                 |   37 ++++++++++++++++++++++++++++---
 drivers/scsi/device_handler/scsi_dh.c |   38 +++++++++++++++++++++++++++++++-
 include/scsi/scsi_dh.h                |    6 +++++
 3 files changed, 75 insertions(+), 6 deletions(-)

-- 
1.7.4.4

