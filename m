From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [ANNOUNCE] scsi patch queue tree
Date: Wed, 21 May 2014 11:25:01 +0900
Message-ID: <1400639101.2481.19.camel@dabdike>
References: <20140519140614.GA12183@infradead.org>
	 <20140520100343.31490551@canb.auug.org.au>
	 <20140520053928.GA1751@infradead.org>
	 <20140521094636.515289e8@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33254 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137AbaEUCZE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2014 22:25:04 -0400
In-Reply-To: <20140521094636.515289e8@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2014-05-21 at 09:46 +1000, Stephen Rothwell wrote:
> Hi Christoph,
> 
> On Mon, 19 May 2014 22:39:28 -0700 Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Tue, May 20, 2014 at 10:03:43AM +1000, Stephen Rothwell wrote:
> > > Is this a request for inclusion of those branches into linux-next
> > > separately from the scsi tree itself?
> > 
> > James said he wants to include it in the scsi tree, but given how late
> > we are in the cycle I'd love to see separate exposure until that happens
> > on a temporary basis.
> 
> OK, I have added them from today (called scsi-core and scsi-drivers).
> James, feel free to yell if that is not OK.

Let's try the process.

>   If these are to stay
> longer term (and I have no objections given your list of requirements),
> then you should rename the branches (maybe to -next instead of -3.16).

I'll merge it into for-next in SCSI to make it easier.

> These will be merged after the scsi tree so that they effectively
> disappear from my radar when they have been merged into James' tree.
> 
> Currently you are the only contact for problems - let me know if I
> should add someone else (or a list).

Also cc the scsi mailing list for merge problems, just in case.

Thanks,

James


