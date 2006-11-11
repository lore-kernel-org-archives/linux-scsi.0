From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.19-rc3 system freezes when ripping with cdparanoia at ioctl(SG_IO)
Date: Sat, 11 Nov 2006 10:46:42 +0000
Message-ID: <20061111104642.GA3356@infradead.org>
References: <4554777B.7050708@torque.net> <508312.85189.qm@web31812.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:19916 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1947190AbWKKKqz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Nov 2006 05:46:55 -0500
Content-Disposition: inline
In-Reply-To: <508312.85189.qm@web31812.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: dougg@torque.net, Tejun Heo <htejun@gmail.com>, Brice Goglin <Brice.Goglin@ens-lyon.org>, Jens Axboe <jens.axboe@oracle.com>, Gregor Jasny <gjasny@googlemail.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, monty@xiph.org, linux-scsi@vger.kernel.org

On Fri, Nov 10, 2006 at 12:08:15PM -0800, Luben Tuikov wrote:
> P.S. I'd love to see SG_DXFER_TO_FROM_DEV completely ripped out
> of sg.c, for obvious reasons.  Can you not duplicate the resid "fix"
> it provides into "FROM_DEV" -- do apps really rely on it?

At the beginning of this thread it was mentioned cdparanio uses it.
But in general we can't just rip out userland interfaces, we pretend
to have a stable userspace abi (and except for the big sysfs mess that
actually comes very close to the truth).

What we should do is to document very well what SG_DXFER_TO_FROM_DEV
is doing and that odd name that's been chosen for it.  I'll prepare
a patch for that.

