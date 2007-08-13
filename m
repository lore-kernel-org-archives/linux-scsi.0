From: joe@perches.com
Subject: [PATCH] [418/2many] MAINTAINERS - SCSI CDROM DRIVER
Date: Sun, 12 Aug 2007 23:35:15 -0700
Message-ID: <46bffba3.92NZRByJnVYnqXQs%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:1726 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967270AbXHMGfa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, akpm@linux-foundation.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c08c8af..d7a1c74 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3981,6 +3981,7 @@ M:	axboe@kernel.dk
 L:	linux-scsi@vger.kernel.org
 W:	http://www.kernel.dk
 S:	Maintained
+F:	drivers/scsi/sr.*
 
 SCSI SG DRIVER
 P:	Doug Gilbert
