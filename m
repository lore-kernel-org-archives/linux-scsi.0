From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [PATCH] wd33c93 updates
Date: Mon, 24 Feb 2003 20:07:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200302242007.15878.oliver@neukum.name>
References: <20030223153007.A9377@lst.de> <1046101213.2288.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1046101213.2288.5.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@lst.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Am Montag, 24. Februar 2003 16:40 schrieb James Bottomley:
> On Sun, 2003-02-23 at 09:30, Christoph Hellwig wrote:
> > The PC98 folks have some updates in their tree to make the generic
> > wd33c93 driver usable in PIO mode, but unfortunately the way they do it
> > (include a header specific to their lowlevel driver in wd33c93.c
> > conditionally) is rather ugly.
>
> OK much as I dislike looking at driver clean ups, this one stood out.
> We don't need each driver to get the command direction by parsing, the
> mid-layer now does it for you.

Hi,

in all cases? And in which kernel versions?

	Regards
		Oliver

