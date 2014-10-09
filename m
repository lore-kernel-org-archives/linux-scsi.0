From: Mark Knibbs <markk@clara.co.uk>
Subject: [PATCH] Fix comment typo in Scsi_Host struct definition
Date: Thu, 9 Oct 2014 12:40:07 +0100
Message-ID: <20141009124007.14ea0a3d09813fc593e1dc21@clara.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [195.8.89.34] ([195.8.89.34]:43601 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751312AbaJILlL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Oct 2014 07:41:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

The comment for the max_channel, max_id and max_lun parameters
refers to the first two, but actually means the last two.

Signed-off-by: Mark Knibbs <markk@clara.co.uk>

---
$ diff -upN linux-3.17/include/scsi/scsi_host.h.orig linux-3.17/include/scsi/scsi_host.h
--- linux-3.17/include/scsi/scsi_host.h.orig	2014-10-05 20:23:04.000000000 +0100
+++ linux-3.17/include/scsi/scsi_host.h	2014-10-09 12:18:47.000000000 +0100
@@ -606,7 +606,7 @@ struct Scsi_Host {
 	/*
 	 * These three parameters can be used to allow for wide scsi,
 	 * and for host adapters that support multiple busses
-	 * The first two should be set to 1 more than the actual max id
+	 * The last two should be set to 1 more than the actual max id
 	 * or lun (e.g. 8 for SCSI parallel systems).
 	 */
 	unsigned int max_channel;
