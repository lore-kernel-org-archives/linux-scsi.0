From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/12] esp_scsi: spellcheck 'driver'
Date: Mon, 24 Nov 2014 15:37:19 +0100
Message-ID: <1416839850-30475-2-git-send-email-hare@suse.de>
References: <1416839850-30475-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254AbaKXOhf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 09:37:35 -0500
In-Reply-To: <1416839850-30475-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Paolo@suse.de, "Bonzini <pbonzini"@redhat.com, "David S. Miller" <davem@davemloft.net>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/esp_scsi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index cd68805..b5862e4 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -1,4 +1,4 @@
-/* esp_scsi.h: Defines and structures for the ESP drier.
+/* esp_scsi.h: Defines and structures for the ESP driver.
  *
  * Copyright (C) 2007 David S. Miller (davem@davemloft.net)
  */
-- 
1.8.5.2

