From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] Format Unit can take many hours
Date: Tue, 11 May 2004 19:27:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040511172753.GY1906@suse.de>
References: <20040511114936.GI4828@tpkurt.garloff.de> <20040511122037.GG1906@suse.de> <40A0FAE9.90900@pobox.com> <20040511161427.GW1906@suse.de> <20040511162638.GU4828@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:25034 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264886AbUEKR3E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2004 13:29:04 -0400
Content-Disposition: inline
In-Reply-To: <20040511162638.GU4828@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Jeff Garzik <jgarzik@pobox.com>, Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>

On Tue, May 11 2004, Kurt Garloff wrote:
> Hi,
> 
> On Tue, May 11, 2004 at 06:14:27PM +0200, Jens Axboe wrote:
> > On Tue, May 11 2004, Jeff Garzik wrote:
> > > Jens Axboe wrote:
> > > >block/scsi_ioctl.c should likely receive similar treatment then.
> > > 
> > > This timeout is dependent on media size, I should think...
> > > 
> > > Is there any reason to think that this timeout will _not_ be continually 
> > > patched in the future, as larger and larger sizes are used?
> 
> The disks gets faster as well.
> 
> But if we have to touch it every three years, I don't see this as a 
> huge problem either. If you want some more room, you can set it to 
> 24hrs now ...

Precisely. No need to over-engineer.
> 
> > I think the timeout is only used for ancient programs that use the old
> > sg interface. Newer programs should pass in the timeout themselves, or
> > set IMMED as somebody else in this thread noted.
> 
> If you do use the sg interface, you can specify the timeout.
> If you use SCSI_IOCTL_SEND_COMMAND, there's no way to do it and
> the value from scsi_ioctl.c applies.

Even the oldest sg interface? SCSI_IOCTL_SEND_COMMAND should have been
put to rest at least 5 years ago :)

-- 
Jens Axboe

