From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] CDC_MMC_WR
Date: 20 Oct 2003 16:58:11 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066690691.2814.21.camel@patehci2>
References: <1065832684.2877.37.camel@patehci2>
	 <20031011082144.GK10614@suse.de>  <1066057325.2253.1.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:6811 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262801AbTJTW6S
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2003 18:58:18 -0400
In-Reply-To: <1066057325.2253.1.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org

I double-checked.

My same -test7 patch applies without complaint to -test8:

patching file drivers/cdrom/cdrom.c
patching file include/linux/cdrom.h
patching file drivers/ide/ide-cd.c
patching file drivers/scsi/sr.c

`diff` thereafter confirms that precisely the same lines have changed as
in -test7.

I'm guessing this patch changes no behaviour except that pdt x05 dvd/cd
devices that support mode page x5A Capabilities thereafter get a chance
via op x46 Get Configuration to end with CDC_MMC_WR unmasked ...

I'm curious to know how wrong I am.

Pat LaVarre


