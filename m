From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] sg: maintainer's website
Date: Thu, 31 Oct 2013 09:10:46 -0400
Message-ID: <527256D6.7030108@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040607010900030205020202"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53018 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab3JaNLM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Oct 2013 09:11:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>

This is a multi-part message in MIME format.
--------------040607010900030205020202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

ChangeLog:
   - update sg MAINTAINERS file entry: web site and documentation
     entry

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------040607010900030205020202
Content-Type: text/x-patch;
 name="sg_maint.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sg_maint.patch"

diff --git a/MAINTAINERS b/MAINTAINERS
index a7c34ef..472b0c6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7316,8 +7316,9 @@ F:	include/scsi/srp.h
 SCSI SG DRIVER
 M:	Doug Gilbert <dgilbert@interlog.com>
 L:	linux-scsi@vger.kernel.org
-W:	http://www.torque.net/sg
+W:	http://sg.danny.cz/sg
 S:	Maintained
+F:	Documentation/scsi/scsi-generic.txt
 F:	drivers/scsi/sg.c
 F:	include/scsi/sg.h
 

--------------040607010900030205020202--
