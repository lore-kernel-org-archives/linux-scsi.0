From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: 2.6.19-rc3 system freezes when ripping with cdparanoia at ioctl(SG_IO)
Date: Sat, 11 Nov 2006 11:09:33 -0800 (PST)
Message-ID: <589461.23187.qm@web31813.mail.mud.yahoo.com>
References: <20061111104642.GA3356@infradead.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20061111104642.GA3356@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: dougg@torque.net, Tejun Heo <htejun@gmail.com>, Brice Goglin <Brice.Goglin@ens-lyon.org>, Jens Axboe <jens.axboe@oracle.com>, Gregor Jasny <gjasny@googlemail.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, monty@xiph.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--- Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Nov 10, 2006 at 12:08:15PM -0800, Luben Tuikov wrote:
> > P.S. I'd love to see SG_DXFER_TO_FROM_DEV completely ripped out
> > of sg.c, for obvious reasons.  Can you not duplicate the resid "fix"
> > it provides into "FROM_DEV" -- do apps really rely on it?
> 
> At the beginning of this thread it was mentioned cdparanio uses it.
> But in general we can't just rip out userland interfaces, we pretend
> to have a stable userspace abi (and except for the big sysfs mess that
> actually comes very close to the truth).

The more reason to think things thorougly when introducing
new code and architecture into a kernel.

     Luben

> What we should do is to document very well what SG_DXFER_TO_FROM_DEV
> is doing and that odd name that's been chosen for it.  I'll prepare
> a patch for that.


