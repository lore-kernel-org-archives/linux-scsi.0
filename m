From: Jens Axboe <axboe@suse.de>
Subject: Re: [linux-usb-devel] Re: Unaligned scatter-gather buffers and usb-storage
Date: Wed, 19 Nov 2003 16:00:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031119150011.GJ1106@suse.de>
References: <20031110095914.B22518@beaverton.ibm.com> <20031118143720.A6411@beaverton.ibm.com> <20031119084729.GA1106@suse.de> <200311191401.34540.oliver@neukum.org> <20031119130400.GG1106@suse.de> <1069252642.10768.7.camel@mulgrave> <20031119143901.GI1106@suse.de> <1069253904.10768.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:64674 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264133AbTKSPBf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 10:01:35 -0500
Content-Disposition: inline
In-Reply-To: <1069253904.10768.13.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Oliver Neukum <oliver@neukum.org>, Patrick Mansfield <patmans@us.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Wed, Nov 19 2003, James Bottomley wrote:
> > > Alternatively, we could add this as yet another parameter to the host
> > > and template structures.  Any preferences?
> > 
> > I suppose you have to, if you want LLD to be able to pass it down.
> 
> Well, what I was fishing for: Is this property useful enough to want
> every device driver writer to think about it (i.e. document and place in
> the template),  or is it rare enough that it should only be accessible
> to those who know what they're doing (via the direct block queue
> interfaces in slave_alloc/configure)?

As far as I'm concerned, requiring 512-byte alignment is 'just
easier'... Only a select few host adapters will set it differently
anyways, so you gain basically nothing.

-- 
Jens Axboe

