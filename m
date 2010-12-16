From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] remove DNS_DELAY in FC local port
Date: Thu, 16 Dec 2010 23:31:57 +0800
Message-ID: <AANLkTi=YX9r=-Os7XzB6STOiRgDemNrd+5cx3N6nSiY8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49251 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab0LPPb6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2010 10:31:58 -0500
Received: by wwa36 with SMTP id 36so2557435wwa.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2010 07:31:57 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: Joe Eykholt <jeykholt@cisco.com>, linux-scsi@vger.kernel.org

The define of DNS_DELAY is removed since it is not used.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_lport.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/libfc/fc_lport.c	2010-12-16 23:35:48.000000000 +0800
@@ -103,7 +103,6 @@
 #define FC_LOCAL_PTP_FID_LO   0x010101
 #define FC_LOCAL_PTP_FID_HI   0x010102

-#define	DNS_DELAY	      3 /* Discovery delay after RSCN (in seconds)*/

 static void fc_lport_error(struct fc_lport *, struct fc_frame *);
