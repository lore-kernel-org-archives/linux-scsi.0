From: joe@perches.com
Subject: [PATCH] [204/2many] MAINTAINERS - FUTURE DOMAIN TMC-16x0 SCSI
 DRIVER (16-bit)
Date: Sun, 12 Aug 2007 23:28:08 -0700
Message-ID: <46bff9f8.oE6xI4+1tFLTvGRu%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:4582 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966592AbXHMG3F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, faith@cs.unc.edu, akpm@linux-foundation.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3bea26f..770b0d8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1952,6 +1952,8 @@ P:	Rik Faith
 M:	faith@cs.unc.edu
 L:	linux-scsi@vger.kernel.org
 S:	Odd fixes (e.g., new signatures)
+F:	drivers/scsi/fdomain.*
+F:	drivers/scsi/pcmcia/fdomain_stub.c
 
 GDT SCSI DISK ARRAY CONTROLLER DRIVER
 P:	Achim Leubner
