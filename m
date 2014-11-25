From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCHv2 00/12] Re-implement am53c974 driver
Date: Tue, 25 Nov 2014 23:10:00 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1411252301320.17362@axis700.grange>
References: <1416573716-73890-1-git-send-email-hare@suse.de>
 <20141124081403.GA18574@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55623 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbaKYWKQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 17:10:16 -0500
In-Reply-To: <20141124081403.GA18574@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Paolo Bonzini <pbonzini@redhat.com>, "David S. Miller" <davem@davemloft.net>, linux-scsi@vger.kernel.org

Hi Christoph,

On Mon, 24 Nov 2014, Christoph Hellwig wrote:

> I'm tempted to merge this into drivers-for-3.19 ASAP, any argument against
> that?  Guennadi, do you have any additional hardware to Hannes one real and one
> virtual adapter to test this new driver on before?

I've got a similar / identical Tekram dc390 SCSI PCI card and a PC with an 
on-board am53c974 chip, but that is either a rather old (2 x PII @ 400MHz 
:)) or a very old (P @ 166MHz) PC of mine, don't think testing on any of 
those would be viable, even if I dig them out from the basement :) More 
interesting would be testing with different devices like tape streamers, 
scanners... But I'm really unsure anyone still uses those, even when I was 
fixing them, I was pretty much the only affected user :)

Thanks
Guennadi

