From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH] Documentation:  Drop reference to dead "sg_def_reserved_size".
Date: Fri, 15 Jun 2007 18:19:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706151817180.26116@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nic.NetDirect.CA ([216.16.235.2]:36175 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbXFOWVY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jun 2007 18:21:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  this entry looks suitably dead, yes?  probably the first in a
regular series of removals.


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 5d0283c..496cef8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1599,8 +1599,6 @@ and is between 256 and 4096 characters. It is defined in the file

 	serialnumber	[BUGS=IA-32]

-	sg_def_reserved_size=	[SCSI]
-
 	shapers=	[NET]
 			Maximal number of shapers.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
