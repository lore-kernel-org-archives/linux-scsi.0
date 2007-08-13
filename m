From: joe@perches.com
Subject: [PATCH] [332/2many] MAINTAINERS - NCR DUAL 700 SCSI DRIVER
 (MICROCHANNEL)
Date: Sun, 12 Aug 2007 23:32:28 -0700
Message-ID: <46bffafc.t12IrGB/yCQsi6yX%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:1226 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967042AbXHMGcn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e372aeb..493de7a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3177,6 +3177,7 @@ P:	James E.J. Bottomley
 M:	James.Bottomley@HansenPartnership.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/NCR_D700.*
 
 NETEM NETWORK EMULATOR
 P:	Stephen Hemminger
