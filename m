From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: TMSCSIM [2.6]
Date: Thu, 27 Nov 2003 23:05:40 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311272106290.11508-100000@poirot.grange>
References: <3FC64CD9.8040505@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:58035 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261276AbTK0WGa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Nov 2003 17:06:30 -0500
In-Reply-To: <3FC64CD9.8040505@yk.rim.or.jp>
List-Id: linux-scsi@vger.kernel.org
To: Chiaki <ishikawa@yk.rim.or.jp>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org, Thorsten Leemhuis <Thorsten_Leemhuis@gmx.de>

Please, try this:

diff -u linux-2.6.0-test10/drivers/scsi/scsiiom.c~ linux-2.6.0-test10/drivers/scsi/scsiiom.c
--- linux-2.6.0-test10/drivers/scsi/scsiiom.c~  Mon Nov 24 23:47:29 2003
+++ linux-2.6.0-test10/drivers/scsi/scsiiom.c   Thu Nov 27 23:02:35 2003
@@ -1749,7 +1749,7 @@
     pSRB->AdaptStatus = 0;
     pSRB->TargetStatus = 0; /* CHECK_CONDITION<<1; */

-    pcmd = pSRB->pcmd;
+//    pcmd = pSRB->pcmd;

     /* We are called from SRBdone, original PCI mapping has been removed
      * already, new one is set up from StartSCSI */

Guennadi
---
Guennadi Liakhovetski


