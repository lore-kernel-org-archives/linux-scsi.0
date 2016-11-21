From: Martin Wilck <mwilck@suse.de>
Subject: [PATCH 0/2] hpsa: fix rmmod issues
Date: Mon, 21 Nov 2016 15:04:27 +0100
Message-ID: <20161121140429.12788-1-mwilck@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35710 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753518AbcKUOE6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 09:04:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: don.brace@pmcs.com
Cc: storagedev@pmcs.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, JBottomley@odin.com, hch@lst.de, hare@suse.de, Martin Wilck <mwilck@suse.de>

This patch set fixes two issues I encountered when removing the
hpsa modules with rmmod.

Comments and reviews are welcome.

Martin Wilck (2):
  hpsa: cleanup sas_phy structures in sysfs when unloading
  hpsa: destroy sas transport properties before scsi_host

 drivers/scsi/hpsa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.10.1

