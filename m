From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: [PATCH] mark qlogicfc broken
Date: Fri, 11 Feb 2005 09:06:14 -0500 (EST)
Message-ID: <Pine.GSO.4.33.0502110847280.5536-100000@sweetums.bluetronic.net>
References: <20050210181815.GB11818@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sweetums.bluetronic.net ([24.199.150.42]:64487 "EHLO
	sweetums.bluetronic.net") by vger.kernel.org with ESMTP
	id S262175AbVBKOH0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2005 09:07:26 -0500
In-Reply-To: <20050210181815.GB11818@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, Linux SCSI List <linux-scsi@vger.kernel.org>

On Thu, 10 Feb 2005, Christoph Hellwig wrote:
>The hardware is supported by qla2xxx which is much better (and
>maintained) driver.  Keeping the driver around confuses people to
>actually use it with severe results, e.g.

That's a nice theory, but not so true in practice.  qla2xxx will not
correctly drive a 2100.  I've complained about this for several years
now and it still doesn't work.  QLogic doesn't test the 2100 anymore.
(Maybe not the 2200's either.)

It's a command queuing problem.  qlogicfc used to have the same problem,
but over the last decade I've managed to stop it from killing itself.
Command queuing to that card cannot be explained as anything but a
cluster f***.  The queue size is dynamic -- dependent on the exact
commands queued.

qlogicfc was removed from the tree once before only to be put back
about 30sec later because people still use it.  It's certainly not
BROKEN.  Not recommended, but not broken either.  BROKEN is a tag for
things that are _broken_ -- they don't compile and don't work when they
do.  qlogicfc both compiles and works, so BROKEN is the wrong thing to
use.

--Ricky


