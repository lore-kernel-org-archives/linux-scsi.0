From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] move ->eh_strategy_handler to the transport class
Date: Sat, 01 Apr 2006 22:57:36 +0200
Message-ID: <1143925056.3076.29.camel@laptopd505.fenrus.org>
References: <20060401172104.GA16921@lst.de>
	 <1143914189.3076.20.camel@laptopd505.fenrus.org>
	 <442EDB68.2060707@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from morbo.e-centre.net ([66.154.82.3]:36861 "EHLO
	cubert.e-centre.net") by vger.kernel.org with ESMTP id S932217AbWDAU5t
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Apr 2006 15:57:49 -0500
In-Reply-To: <442EDB68.2060707@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Sat, 2006-04-01 at 21:58 +0200, Stefan Richter wrote:
> Arjan van de Ven wrote:
> > On Sat, 2006-04-01 at 19:21 +0200, Christoph Hellwig wrote:
> >>Overriding the whole EH code is a per-transport, not per-host thing.
> >>Move ->eh_strategy_handler to the transport class, same as
> >>->eh_timed_out.
> > 
> > I like it, nice cleanup and it's fundamentally the right place to do it
> 
> BTW, why are there Scsi_Hosts in (s)ata drivers anyway instead of being 
> hidden by libata? (Think of libata---or a transport class---as a layer.)

this is basically how linux does OOP :)

the lowest level driver instantiates the object, but sets it with
helper/library functions ("methods" in OOP speak) from the higher
layers.

It gives a really clean model in the light of a world where 
"hardware does weird shit" which can't be "nicely" mapped in traditional
OOP paradigms, but works quite well in this linux model.


