From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [linux-usb-devel] Re: Unaligned scatter-gather buffers and
 usb-storage
Date: Wed, 19 Nov 2003 18:56:38 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0311191854560.2166@kai.makisara.local>
References: <20031110095914.B22518@beaverton.ibm.com> <20031118143720.A6411@beaverton.ibm.com>
 <20031119084729.GA1106@suse.de> <200311191401.34540.oliver@neukum.org>
 <20031119130400.GG1106@suse.de> <1069252642.10768.7.camel@mulgrave>
 <20031119143901.GI1106@suse.de> <1069253904.10768.13.camel@mulgrave>
 <20031119150011.GJ1106@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:10829 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S264060AbTKSUH4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 15:07:56 -0500
In-Reply-To: <20031119150011.GJ1106@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, Patrick Mansfield <patmans@us.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Wed, 19 Nov 2003, Jens Axboe wrote:

> On Wed, Nov 19 2003, James Bottomley wrote:
> > > > Alternatively, we could add this as yet another parameter to the host
> > > > and template structures.  Any preferences?
> > >
> > > I suppose you have to, if you want LLD to be able to pass it down.
> >
> > Well, what I was fishing for: Is this property useful enough to want
> > every device driver writer to think about it (i.e. document and place in
> > the template),  or is it rare enough that it should only be accessible
> > to those who know what they're doing (via the direct block queue
> > interfaces in slave_alloc/configure)?
>
> As far as I'm concerned, requiring 512-byte alignment is 'just
> easier'... Only a select few host adapters will set it differently
> anyways, so you gain basically nothing.
>
As usual, I am against this 512-byte alignment (thinking as st
maintainer). Don't default to more strict aligment requirements than is
necessary. It creates hidden performance problems for character device
drivers.

-- 
Kai
