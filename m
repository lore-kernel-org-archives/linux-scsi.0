From: joe@perches.com
Subject: [PATCH] [420/2many] MAINTAINERS - SCSI SUBSYSTEM
Date: Sun, 12 Aug 2007 23:35:19 -0700
Message-ID: <46bffba7.a/HzsshGBNUiTFM7%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:1736 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967076AbXHMGfd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, James.Bottomley@SteelEye.com

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c156f9f..c4d29d9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3998,6 +3998,8 @@ M:	James.Bottomley@SteelEye.com
 L:	linux-scsi@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
 S:	Maintained
+F:	drivers/scsi/
+F:	include/scsi/
=20
 SCSI TAPE DRIVER
 P:	Kai M=E4kisara
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
