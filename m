From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Correct two-byte message descriptions
Date: Tue, 13 Dec 2005 06:29:36 -0700
Message-ID: <20051213132936.GK9286@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35018 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932172AbVLMN3h
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2005 08:29:37 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add missing comma.   Ordered Queue Tag and Ignore Wide Residue were
being concatenated together.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: drivers/scsi/constants.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/constants.c,v
retrieving revision 1.12
retrieving revision 1.13
diff -u -p -r1.12 -r1.13
--- a/drivers/scsi/constants.c	12 Nov 2005 04:08:09 -0000	1.12
+++ b/drivers/scsi/constants.c	13 Dec 2005 00:01:16 -0000	1.13
@@ -1291,5 +1291,5 @@ static const char *one_byte_msgs[] = {
 
 static const char *two_byte_msgs[] = {
-/* 0x20 */ "Simple Queue Tag", "Head of Queue Tag", "Ordered Queue Tag"
+/* 0x20 */ "Simple Queue Tag", "Head of Queue Tag", "Ordered Queue Tag",
 /* 0x23 */ "Ignore Wide Residue"
 };
