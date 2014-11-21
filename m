From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/12] esp_scsi: spellcheck 'driver'
Date: Fri, 21 Nov 2014 13:41:45 +0100
Message-ID: <1416573716-73890-2-git-send-email-hare@suse.de>
References: <1416573716-73890-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbaKUMmA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 07:42:00 -0500
In-Reply-To: <1416573716-73890-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, "David S. Miller" <davem@davemloft.net>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
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

