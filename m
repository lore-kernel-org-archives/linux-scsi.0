From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/2] convert libsas to the libata new eh
Date: Wed, 26 Jan 2011 12:46:46 -0500
Message-ID: <4D405E06.5020400@garzik.org>
References: <1295797260.3007.118.camel@mulgrave.site> <4D3F1CC6.5080208@linux.vnet.ibm.com> <1296050931.4893.9.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54327 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab1AZRqu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jan 2011 12:46:50 -0500
In-Reply-To: <1296050931.4893.9.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Robert Jennings <rcj@linux.vnet.ibm.com>, Wayne Boyer <wayneb@linux.vnet.ibm.com>

On 01/26/2011 09:08 AM, James Bottomley wrote:
> I think better might be to move the eh thread functionality into block.
> What libata really wants is one eh thread per phy.  It gets this by
[...]
> machinery, everyone should get what they want, and libata could dispense
> with its current corruption of multiple SCSI hosts per physical bus
> attachment.

That's not the whole picture.  libata originally chose one-host-per-port 
because that winds up being the best queueing/queue-busy arrangement for 
legacy IDE ports.  They behave quite similarly to independent 
controllers -- even to the point of having separate irqs -- even though 
multiple IDE ports are shoehorned into a single PCI device.

	Jeff


