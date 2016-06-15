From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] 53c700: fix BUG on untagged commands
Date: Tue, 14 Jun 2016 20:31:51 -0700
Message-ID: <1465961511.2273.107.camel@linux.vnet.ibm.com>
References: <1465880407.18583.18.camel@linux.vnet.ibm.com>
	 <20160614150555.GA698@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <20160614150555.GA698@infradead.org>
Sender: linux-parisc-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Parisc List <linux-parisc@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-06-14 at 08:05 -0700, Christoph Hellwig wrote:
> Looks fine:
> 
> Acked-by: Christoph Hellwig <hch@lst.de>
> 
> But it should really go together with something like this:

Well, we need the simplest fix to backport, which is why I sent what I
did.

> ---
> From e54d1462ae244db3189a8b69018bc5f3e3d3b468 Mon Sep 17 00:00:00
> 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Tue, 14 Jun 2016 17:04:10 +0200
> Subject: scsi: move current_cmnd into the 53c700 driver
> 
> The 53c700 driver is the only user of the current_cmnd field in
> struct scsi_device, so let's move it into the driver private data.

The style in the driver is to use accessor functions for device
parameters, but I don't see it matters much since the day anyone would
write a new SPI driver (for which this was often the template) is long
gone.

James

