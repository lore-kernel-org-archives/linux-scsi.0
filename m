From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Mon, 29 May 2006 07:19:00 -0600
Message-ID: <20060529131900.GA20416@parisc-linux.org>
References: <20060511143352.GI12272@parisc-linux.org> <20060518172258.GL1604@parisc-linux.org> <20060529031915.GB23405@parisc-linux.org> <447AB2F5.2000700@s5r6.in-berlin.de> <20060529130515.GE23405@parisc-linux.org> <1148908267.3291.82.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42410 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750828AbWE2NTB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 May 2006 09:19:01 -0400
Content-Disposition: inline
In-Reply-To: <1148908267.3291.82.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Mon, May 29, 2006 at 03:11:07PM +0200, Arjan van de Ven wrote:
> > That's what scsi_complete_async_scans() is for.  If you have a built-in
> > module, it will wait for the async scans to finish before we get as far
> > as trying to mount root.
> 
> that sounds the wrong place, at least, I would expect the wait is needed
> before starting the initramfs, since that is where some distros mount
> their root (mount-by-label and I suspect many other cases will do it
> from there, such as iscsi rootfs etc)

It's a late_initcall(), so it happens before initramfs too.

