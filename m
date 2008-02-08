From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] scsi_error: Fix language abuse.
Date: Fri, 8 Feb 2008 15:32:17 +0000
Message-ID: <20080208153217.5fc42a50@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52221 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755717AbYBHPin (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 10:38:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


The word "illegal" has a precise dictionary meaning of "prohibited by
law". The error messages are therefore incorrect as so far nobody has
made SCSI violations a criminal offence.

This corrects scsi to match various other subsystems I've slowly been
ridding of this.

Pedantically-signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-mm1/drivers/scsi/constants.c linux-2.6.24-mm1/drivers/scsi/constants.c
--- linux.vanilla-2.6.24-mm1/drivers/scsi/constants.c	2008-02-06 14:14:40.000000000 +0000
+++ linux-2.6.24-mm1/drivers/scsi/constants.c	2008-02-06 14:35:16.000000000 +0000
@@ -606,10 +606,10 @@
 	{0x2001, "Access denied - initiator pending-enrolled"},
 	{0x2002, "Access denied - no access rights"},
 	{0x2003, "Access denied - invalid mgmt id key"},
-	{0x2004, "Illegal command while in write capable state"},
+	{0x2004, "Invalid command while in write capable state"},
 	{0x2005, "Obsolete"},
-	{0x2006, "Illegal command while in explicit address mode"},
-	{0x2007, "Illegal command while in implicit address mode"},
+	{0x2006, "Invalid command while in explicit address mode"},
+	{0x2007, "Invalid command while in implicit address mode"},
 	{0x2008, "Access denied - enrollment conflict"},
 	{0x2009, "Access denied - invalid LU identifier"},
 	{0x200A, "Access denied - invalid proxy token"},
@@ -620,7 +620,7 @@
 	{0x2102, "Invalid address for write"},
 	{0x2103, "Invalid write crossing layer jump"},
 
-	{0x2200, "Illegal function (use 20 00, 24 00, or 26 00)"},
+	{0x2200, "Invalid function (use 20 00, 24 00, or 26 00)"},
 
 	{0x2400, "Invalid field in cdb"},
 	{0x2401, "CDB decryption error"},
@@ -697,7 +697,7 @@
 	{0x2C02, "Invalid combination of windows specified"},
 	{0x2C03, "Current program area is not empty"},
 	{0x2C04, "Current program area is empty"},
-	{0x2C05, "Illegal power condition request"},
+	{0x2C05, "Invalid power condition request"},
 	{0x2C06, "Persistent prevent conflict"},
 	{0x2C07, "Previous busy status"},
 	{0x2C08, "Previous task set full status"},
@@ -1014,7 +1014,7 @@
 	{0x6300, "End of user area encountered on this track"},
 	{0x6301, "Packet does not fit in available space"},
 
-	{0x6400, "Illegal mode for this track"},
+	{0x6400, "Invalid mode for this track"},
 	{0x6401, "Invalid packet size"},
 
 	{0x6500, "Voltage fault"},
@@ -1124,7 +1124,7 @@
 	"Not Ready",	    /* 2: The addressed target is not ready */
 	"Medium Error",	    /* 3: Data error detected on the medium */
 	"Hardware Error",   /* 4: Controller or device failure */
-	"Illegal Request",  /* 5: Error in request */
+	"Invalid Request",  /* 5: Error in request */
 	"Unit Attention",   /* 6: Removable medium was changed, or
 				  the target has been reset, or ... */
 	"Data Protect",	    /* 7: Access to the data is blocked */
