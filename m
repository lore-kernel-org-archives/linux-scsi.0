From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH] Documentation:  Delete final reference to "sg_def_reserved_size"
 kernel parm.
Date: Thu, 30 Aug 2007 03:54:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0708300350460.5178@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nic.NetDirect.CA ([216.16.235.2]:39168 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbXH3IFg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Aug 2007 04:05:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: trivial@kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  given the following:

$ grep -rw sg_def_reserved_size *
Documentation/kernel-parameters.txt:    sg_def_reserved_size=   [SCSI]
$

that kernel parameter looks exceedingly dead.


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b41cde3..fe43fc5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1562,8 +1562,6 @@ and is between 256 and 4096 characters. It is defined in the file

 	serialnumber	[BUGS=X86-32]

-	sg_def_reserved_size=	[SCSI]
-
 	shapers=	[NET]
 			Maximal number of shapers.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
