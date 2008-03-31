From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/9] zfcp: Remove obsolete output function from debug trace.
Date: Mon, 31 Mar 2008 11:15:25 +0200
Message-ID: <20080331091831.269784000@de.ibm.com>
References: <20080331091522.688709000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:32969 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbYCaJSe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2008 05:18:34 -0400
Content-Disposition: inline; filename=zfcp_dbf_cleanup_rm_unused_view_function.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

Remove obsolete output function.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 14:58:34.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 14:58:47.000000000 +0100
@@ -74,21 +74,6 @@ static int zfcp_dbf_tag(char *out_buf, c
 	return len;
 }
 
-static int
-zfcp_dbf_view(char *out_buf, const char *label, const char *format, ...)
-{
-	va_list arg;
-	int len = 0;
-
-	len += sprintf(out_buf + len, "%-24s", label);
-	va_start(arg, format);
-	len += vsprintf(out_buf + len, format, arg);
-	va_end(arg);
-	len += sprintf(out_buf + len, "\n");
-
-	return len;
-}
-
 static void zfcp_dbf_outs(char **buf, const char *s1, const char *s2)
 {
 	*buf += sprintf(*buf, "%-24s%s\n", s1, s2);

-- 
