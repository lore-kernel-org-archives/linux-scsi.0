From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH resend] scsi boot options: correct option name and tell
 where to find docs for it
Date: Wed, 14 Nov 2007 16:52:25 -0800
Message-ID: <20071114165225.57932322.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:15796 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbXKOAw5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Nov 2007 19:52:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Minor corrections and additions to 'scsi_logging_level', as pointed out
by Chuck Ebbert.
Also point out the IBM S390-tools 'scsi_logging_level' script.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- linux-2.6.24-rc2-git4.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.24-rc2-git4/Documentation/kernel-parameters.txt
@@ -1584,7 +1584,13 @@ and is between 256 and 4096 characters. 
 			Format: <vendor>:<model>:<flags>
 			(flags are integer value)
 
-	scsi_logging=	[SCSI]
+	scsi_logging_level=	[SCSI] a bit mask of logging levels
+			See drivers/scsi/scsi_logging.h for bits.  Also
+			settable via sysctl at dev.scsi.logging_level
+			(/proc/sys/dev/scsi/logging_level).
+			There is also a nice 'scsi_logging_level' script in the
+			S390-tools package, available for download at
+			http://www-128.ibm.com/developerworks/linux/linux390/s390-tools-1.5.4.html
 
 	scsi_mod.scan=	[SCSI] sync (default) scans SCSI busses as they are
 			discovered.  async scans them in kernel threads,

