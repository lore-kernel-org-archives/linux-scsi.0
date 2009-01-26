From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][SCST]: Update of text in SCST README about barriers usage
Date: Mon, 26 Jan 2009 21:19:18 +0300
Message-ID: <497DFEA6.1080108@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:59762 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZAZSTM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2009 13:19:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net

This patch updates text in SCST README about barriers usage

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>

 README |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

Index: scst/README
===================================================================
--- scst/README	(revision 641)
+++ scst/README	(working copy)
@@ -607,12 +607,11 @@ IMPORTANT: By default for performance re
 	   On Linux initiators for EXT3 and ReiserFS file systems the
 	   barrier protection could be turned on using "barrier=1" and
 	   "barrier=flush" mount options correspondingly. Note, that
-	   usually it turned off by default and the status of barriers
-	   usage isn't reported anywhere in the system logs as well as
-	   there is no way to know it on the mounted file system (at
-	   least no known one). Windows and, AFAIK, other UNIX'es don't
-	   need any special explicit options and do necessary barrier
-	   actions on write-back caching devices by default. Also note
+	   usually it's turned off by default (see http://lwn.net/Articles/283161).
+	   You can check if it's turn on or off by looking in /proc/mounts.
+	   Windows and, AFAIK, other UNIX'es don't need any special
+	   explicit options and do necessary barrier actions on
+	   write-back caching devices by default. Also note
 	   that on some real-life workloads write through caching might
 	   perform better, than write back one with the barrier
 	   protection turned on.

