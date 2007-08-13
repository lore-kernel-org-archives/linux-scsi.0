From: joe@perches.com
Subject: [PATCH] [486/2many] MAINTAINERS - U14-34F SCSI DRIVER
Date: Sun, 12 Aug 2007 23:37:39 -0700
Message-ID: <46bffc33.soe/Y4NC9xOEjIkz%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:2118 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938964AbXHMGhy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ballabio_dario@emc.com, akpm@linux-foundation.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 374ee9b..e28c8d4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4609,6 +4609,7 @@ P:	Dario Ballabio
 M:	ballabio_dario@emc.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/u14-34f.c
 
 UDF FILESYSTEM
 P:	Ben Fennema
