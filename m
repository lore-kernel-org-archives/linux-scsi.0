From: Pozsar Balazs <pozsy@uhulinux.hu>
Subject: Re: SCSI Initio 9100UW (INIC-950p chipset) support nunder kernel 2.6.x
Date: Wed, 22 Sep 2004 22:14:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040922201424.GC2098@unicorn.sch.bme.hu>
References: <4151A24A.7000302@fabricadeideias.com> <20040922170651.A3340@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from unicorn.sch.bme.hu ([152.66.208.4]:52375 "EHLO
	unicorn.sch.bme.hu") by vger.kernel.org with ESMTP id S267235AbUIVUOl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 16:14:41 -0400
Content-Disposition: inline
In-Reply-To: <20040922170651.A3340@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Rodrigo Severo <rodrigo.lists@fabricadeideias.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Sep 22, 2004 at 05:06:51PM +0100, Christoph Hellwig wrote:
> On Wed, Sep 22, 2004 at 01:03:00PM -0300, Rodrigo Severo wrote:
> > with kernel 2.4.24 (yes, I know it's old).
> > 
> > I want to update my kernel do 2.6.8. The question: is there support for 
> > this board/chipset under kernel 2.6.x?
> > 
> > I looked around a lot and couldn't find much. www.initio.com says their 
> > code is in the kernel since 2.0.32. Has it been left out for 2.6.x?
> > 
> > Is anyone working on this port? Anyone intending to work on it?
> 
> The driver still exists and actually compiles.  It's marked BROKEN, although
> I don't know why.  If you want to help testing we can update it to current
> standards.

It works perfectly for me. (I have 1 disk and 1 cdrom.)

Also note that mandrake ships a kernel with the BROKEN flag patched off.

I do not know why was it marked as such.


-- 
pozsy
