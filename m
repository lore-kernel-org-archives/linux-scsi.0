From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] mark qlogicfc broken
Date: Fri, 11 Feb 2005 15:10:15 +0100
Message-ID: <20050211141015.GA28665@lst.de>
References: <20050210181815.GB11818@lst.de> <Pine.GSO.4.33.0502110847280.5536-100000@sweetums.bluetronic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:59268 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262178AbVBKOKV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2005 09:10:21 -0500
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.33.0502110847280.5536-100000@sweetums.bluetronic.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ricky Beam <jfbeam@bluetronic.net>
Cc: jejb@steeleye.com, Linux SCSI List <linux-scsi@vger.kernel.org>

On Fri, Feb 11, 2005 at 09:06:14AM -0500, Ricky Beam wrote:
> On Thu, 10 Feb 2005, Christoph Hellwig wrote:
> >The hardware is supported by qla2xxx which is much better (and
> >maintained) driver.  Keeping the driver around confuses people to
> >actually use it with severe results, e.g.
> 
> That's a nice theory, but not so true in practice.  qla2xxx will not
> correctly drive a 2100.  I've complained about this for several years
> now and it still doesn't work.  QLogic doesn't test the 2100 anymore.
> (Maybe not the 2200's either.)

Arjan tested it on the 2100 a while ago and it worked just fine.  Have
you tested it recently?

> qlogicfc was removed from the tree once before only to be put back
> about 30sec later because people still use it.  It's certainly not
> BROKEN.  Not recommended, but not broken either.  BROKEN is a tag for
> things that are _broken_ -- they don't compile and don't work when they
> do.  qlogicfc both compiles and works, so BROKEN is the wrong thing to
> use.

It _is_ broken.  See the url in my initial post.

