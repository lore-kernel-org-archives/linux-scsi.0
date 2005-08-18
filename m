From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Thu, 18 Aug 2005 16:05:29 -0400
Message-ID: <4304EA09.1070804@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A35@xbl3.ma.emulex.com> <20050818175648.GA27894@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:42947 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932383AbVHRUFe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2005 16:05:34 -0400
In-Reply-To: <20050818175648.GA27894@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Smart@Emulex.Com, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On 08/18/05 13:56, Christoph Hellwig wrote:
> I was trying to avoid the need for an rport object, but I'm not yet sure
> it's feasible.  We certainly won't put in target-persistency support
> similar to FC, that was just a hack to get the existing drivers migrated
> without lots of complaints, it's not going in for new transports like
> SAS or iSCSI.

Hmm, I remember working on iSCSI exactly 5 years ago.
Is this considered new?  (er, I mean in light of SCSI Core)

I also remember it was that time when I asked about 8 byte LUNs
to be supported transparently by SCSI Core.

It was also that time when I asked for "target" to be supported
without "channel" and "id" as this had to be invented by
the iSCSI LLDD as it needs to be invented by FC and USB.

It was also that time when I asked for "target" to be
represented transparently so that SCSI Core can do LU
discovery and register the devices found and register
them with the Command Set Drivers (sd, st, etc).

On all three points I saw great opposition from the maintainers.

Sadly, I had implemented all those things, but the products
(target and initiator) was closed source.

This is where scsi_done_q and scsi commands from slab cache came from...

>  What we might need an rport for is to support SMP.  I'm
> not yet sure how to do SMP passthrough, but we will need some object
> to represent SMP ports.

Why?  How is this going to be used?  What is the architecture model?

	Luben
