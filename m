From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.6.2-rc2 - MPT Fusion driver 3.00.02 update
Date: 26 Jan 2004 19:10:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075165833.1834.13.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E5703D19D2F@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:53484 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261567AbUA0BKf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2004 20:10:35 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703D19D2F@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@infradead.org

This causes a compile failure when CONFIG_PM isn't defined.  I think the
attached is the fix.

James

===== drivers/message/fusion/mptbase.h 1.13 vs edited =====
--- 1.13/drivers/message/fusion/mptbase.h	Mon Jan 26 11:56:15 2004
+++ edited/drivers/message/fusion/mptbase.h	Mon Jan 26 17:25:05 2004
@@ -186,8 +186,8 @@
 	int  (*suspend) (struct pci_dev *dev, u32 state);
 #ifdef CONFIG_PM
 	int  (*resume) (struct pci_dev *dev);
-	void (*shutdown) (struct device * dev);
 #endif
+	void (*shutdown) (struct device * dev);
 };
 
 /*

