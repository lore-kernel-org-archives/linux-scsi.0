From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC][PATCH] libata ATAPI alignment
Date: Tue, 02 Aug 2005 10:31:36 -0400
Message-ID: <42EF83C8.3070003@pobox.com>
References: <20050729050654.GA10413@havoc.gtf.org> <20050802082719.GA22569@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:64999 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261573AbVHBObp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2005 10:31:45 -0400
In-Reply-To: <20050802082719.GA22569@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>

Jens Axboe wrote:
> On Fri, Jul 29 2005, Jeff Garzik wrote:
>>diff --git a/drivers/scsi/ahci.c b/drivers/scsi/ahci.c
>>--- a/drivers/scsi/ahci.c
>>+++ b/drivers/scsi/ahci.c
>>@@ -44,7 +44,7 @@
>> 
>> enum {
>> 	AHCI_PCI_BAR		= 5,
>>-	AHCI_MAX_SG		= 168, /* hardware max is 64K */
>>+	AHCI_MAX_SG		= 300, /* hardware max is 64K */
>> 	AHCI_DMA_BOUNDARY	= 0xffffffff,
>> 	AHCI_USE_CLUSTERING	= 0,
>> 	AHCI_CMD_SLOT_SZ	= 32 * 32,
> 
> 
> Reasoning? I agree, just wondering... How big is the allocated area now?

168 kept the entire allocated DMA area to 4K.

300 increases that to <I don't care>K.  ;-)

	Jeff


