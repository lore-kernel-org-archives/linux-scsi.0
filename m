From: joe@perches.com
Subject: [PATCH] [421/2many] MAINTAINERS - SCSI TAPE DRIVER
Date: Sun, 12 Aug 2007 23:35:21 -0700
Message-ID: <46bffba9.6+Hv0+R8yAp+v2wI%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:1755 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967261AbXHMGfl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Kai.Makisara@kolumbus.fi

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c4d29d9..2e15975 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4006,6 +4006,7 @@ P:	Kai M=E4kisara
 M:	Kai.Makisara@kolumbus.fi
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/st*
=20
 SCTP PROTOCOL
 P:	Vlad Yasevich
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
