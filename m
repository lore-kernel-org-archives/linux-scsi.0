From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH]: Fix Ultrastor asm snippet
Date: Tue, 24 May 2011 13:28:44 -0400
Message-ID: <1306258124.10201.22.camel@mulgrave.site>
References: <20110518150605.GA25262@const.bordeaux.inria.fr>
	 <20110520130215.GB3428@infradead.org>
	 <20110520142459.4c37d3e0@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36763 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932161Ab1EXVck (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2011 17:32:40 -0400
In-Reply-To: <20110520142459.4c37d3e0@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Samuel Thibault <samuel.thibault@ens-lyon.org>, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org

On Fri, 2011-05-20 at 14:24 +0100, Alan Cox wrote:
> On Fri, 20 May 2011 09:02:15 -0400
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Wed, May 18, 2011 at 05:06:05PM +0200, Samuel Thibault wrote:
> > > Commit 1292500b replaced
> > > 
> > > "=m" (*field) : "1" (*field)
> > > 
> > > with
> > > 
> > > "=m" (*field) :
> > > 
> > > with comment "The following patch fixes it by using the '+' operator on
> > > the (*field) operand, marking it as read-write to gcc."
> > > '+' was actually forgotten.  This really puts it.
> > 
> > Do you actually have the hardware or was this just a code audit?
> > 
> > I have the strong suspicion that this driver is pretty much dead and
> > bitrotting.
> 
> There are a pile of scsi drivers like the Ultrastor that probably want
> retiring via staging.

OK, can someone work out how we do this and then send the patch (I
assume it's just an update in the deprecated features and a move to
staging?)

> I can believe an AHA152x or two lurk around,

Yes, got one ... and occasionally even test with it.

>  and the odd NCR53c80 and
> clones because they were so voluminous but the rest I doubt somewhat.

James


