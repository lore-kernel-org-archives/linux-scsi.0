From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Re: libata: BLKFLSBUF ioctl broken
Date: Fri, 22 Oct 2004 21:31:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098477101.19435.46.camel@localhost.localdomain>
References: <200410221942.i9MJguMR017671@falcon30.maxeymade.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:39138 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S268001AbUJVVew (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 17:34:52 -0400
In-Reply-To: <200410221942.i9MJguMR017671@falcon30.maxeymade.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@maxeymade.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Mark Lord <lsml@rtr.ca>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

On Gwe, 2004-10-22 at 20:42, Doug Maxey wrote:
> >We are slowly fixing the abusers of -EINVAL/-EOPNOTSUPP. Note btw that
> >networking stuff is in many places a little different in its returns.
> 
> What about the case of "This is normally a valid command, but this
> particulat device is incapable of this particular subcommand"?
> 
> Hypothetical instance: a disk drive that indicates it is not capable of 
> changing it's write cache setting?

Thats less clear. Traditional Unix has tended to use EINVAL for that
too, while Linux re-uses things like EOPNOTSUPP and that may well be a
better approach - its at least fairly consistent in Linux.

