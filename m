From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] 2.6.2-rc2 - MPT Fusion driver 3.00.02 update
Date: Mon, 26 Jan 2004 22:18:00 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040127061800.GB429536@sgi.com>
References: <0E3FA95632D6D047BA649F95DAB60E5703D19D33@exa-atlanta.se.lsil.com> <1075136727.2290.48.camel@mulgrave> <20040126193413.A3302@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:62403 "EHLO zok.sgi.com")
	by vger.kernel.org with ESMTP id S262902AbUA0GSr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2004 01:18:47 -0500
Content-Disposition: inline
In-Reply-To: <20040126193413.A3302@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, "Moore, Eric Dean" <Emoore@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jan 26, 2004 at 07:34:13PM +0000, Christoph Hellwig wrote:
> On Mon, Jan 26, 2004 at 11:05:26AM -0600, James Bottomley wrote:
> > > I had avoided it due the comments in the code
> > > from sralston and pdelaney about sg interface 
> > > gererating wrong direction in some cases.  
> > 
> > If you find a problem, I'll fix the generic code...
> 
> I think it's just very old comments.  We had such a problem in early 2.4
> kernels, but it has been fixed for ages.  If it wasn't most of the scsi
> drivers would have a big problem.

Aren't there three interfaces for sg, or did the early ones go away
in 2.6?  I recall that we ran into trouble with sg setting the
direction incorrectly in 2.4 kernels when using older interface,
I think.

jeremy
