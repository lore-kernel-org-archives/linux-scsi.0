From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH]: Fix Ultrastor asm snippet
Date: Fri, 20 May 2011 14:24:59 +0100
Message-ID: <20110520142459.4c37d3e0@lxorguk.ukuu.org.uk>
References: <20110518150605.GA25262@const.bordeaux.inria.fr>
	<20110520130215.GB3428@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110520130215.GB3428@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 20 May 2011 09:02:15 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, May 18, 2011 at 05:06:05PM +0200, Samuel Thibault wrote:
> > Commit 1292500b replaced
> > 
> > "=m" (*field) : "1" (*field)
> > 
> > with
> > 
> > "=m" (*field) :
> > 
> > with comment "The following patch fixes it by using the '+' operator on
> > the (*field) operand, marking it as read-write to gcc."
> > '+' was actually forgotten.  This really puts it.
> 
> Do you actually have the hardware or was this just a code audit?
> 
> I have the strong suspicion that this driver is pretty much dead and
> bitrotting.

There are a pile of scsi drivers like the Ultrastor that probably want
retiring via staging.

I can believe an AHA152x or two lurk around, and the odd NCR53c80 and
clones because they were so voluminous but the rest I doubt somewhat.
