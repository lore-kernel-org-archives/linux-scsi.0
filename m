From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 0/4] failover fixes for scsi_dh_alua
Date: Fri, 12 May 2017 15:15:04 +0200
Message-ID: <20170512131508.3231-1-mwilck@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:37872 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751900AbdELNPo (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Fri, 12 May 2017 09:15:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

Here are 4 fixes we came up with at SUSE to fix problems we encountered
in multipath failover tests. Feedback welcome.

Best regards,
Martin

Changes wrt v1:

- Use a constant value for the retry interval in patch 1/4
- Style fix in patch 2/4
- Safer coding in patch 3/4 as suggested by Bart
- Protect against sdev being released, as suggested by Bart (added patch 4/4)

Hannes Reinecke (2):
  scsi_dh_alua: Do not modify the interval value for retries
  scsi_dh_alua: Do not retry for unmapped device

Martin Wilck (2):
  scsi_dh_alua: do not call BUG_ON when updating port group
  scsi_dh_alua: take sdev reference in alua_bus_attach

 drivers/scsi/device_handler/scsi_dh_alua.c | 51 +++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 18 deletions(-)

-- 
2.12.2
