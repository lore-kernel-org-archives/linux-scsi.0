From: Joe Perches <joe@perches.com>
Subject: [PATCH] MAINTAINERS: Remove two ancient EATA sections
Date: Sat, 28 Jun 2014 09:54:02 -0700
Message-ID: <1403974442.9064.25.camel@joe-AO725>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0089.hostedemail.com ([216.40.44.89]:51380 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751490AbaF1QyG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Jun 2014 12:54:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

These haven't had a single ack by the listed maintainer
in all git history and the email addresses don't work.

And entry for Michael Neuffer is already in CREDITS.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8ea4305..93aa52b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3189,26 +3189,12 @@ T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
 F:	drivers/media/tuners/e4000*
 
-EATA-DMA SCSI DRIVER
-M:	Michael Neuffer <mike@i-Connect.Net>
-L:	linux-eata@i-connect.net
-L:	linux-scsi@vger.kernel.org
-S:	Maintained
-F:	drivers/scsi/eata*
-
 EATA ISA/EISA/PCI SCSI DRIVER
 M:	Dario Ballabio <ballabio_dario@emc.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/eata.c
 
-EATA-PIO SCSI DRIVER
-M:	Michael Neuffer <mike@i-Connect.Net>
-L:	linux-eata@i-connect.net
-L:	linux-scsi@vger.kernel.org
-S:	Maintained
-F:	drivers/scsi/eata_pio.*
-
 EC100 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org


