From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/3] failover fixes for scsi_dh_alua
Date: Fri, 28 Apr 2017 15:06:23 +0200
Message-ID: <20170428130626.32162-1-mwilck@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46131 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1162243AbdD1NG5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Apr 2017 09:06:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

Here are 3 fixes we came up with at SUSE to fix problems we encountered
in multipath failover tests. Feedback welcome.

Best regards,
Martin

Hannes Reinecke (2):
  scsi_dh_alua: Do not modify the interval value for retries
  scsi_dh_alua: Do not retry for unmapped device

Martin Wilck (1):
  scsi_dh_alua: do not call BUG_ON when updating port group

 drivers/scsi/device_handler/scsi_dh_alua.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

-- 
2.12.2
