From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] wd33c93 updates
Date: 24 Feb 2003 14:17:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1046114271.1720.22.camel@mulgrave>
References: <20030223153007.A9377@lst.de>
	<1046101213.2288.5.camel@mulgrave>  <200302242007.15878.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id LAA27844
	for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2003 11:17:55 -0800
In-Reply-To: <200302242007.15878.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-02-24 at 14:07, Oliver Neukum wrote:
> Am Montag, 24. Februar 2003 16:40 schrieb James Bottomley:
> > On Sun, 2003-02-23 at 09:30, Christoph Hellwig wrote:
> > > The PC98 folks have some updates in their tree to make the generic
> > > wd33c93 driver usable in PIO mode, but unfortunately the way they do it
> > > (include a header specific to their lowlevel driver in wd33c93.c
> > > conditionally) is rather ugly.
> >
> > OK much as I dislike looking at driver clean ups, this one stood out.
> > We don't need each driver to get the command direction by parsing, the
> > mid-layer now does it for you.
> 
> Hi,
> 
> in all cases? And in which kernel versions?

Well, definitely all of 2.5 and most of 2.4.  I think it was done early
on in 2.3 actually as part of the Eric Youngdale clean ups, but I don't
have the exact version to hand.

James


