From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] link scsi_debug later
Date: Fri, 17 Mar 2006 22:19:20 -0800
Message-ID: <20060317221920.3c84fc65.rdunlap@xenotime.net>
References: <20060317124407.5f19cc09.rdunlap@xenotime.net>
	<20060317212924.11a86800.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:16339 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751580AbWCRGRR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 01:17:17 -0500
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 17 Mar 2006 22:17:16 -0800
In-Reply-To: <20060317212924.11a86800.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, james.bottomley@steeleye.com

On Fri, 17 Mar 2006 21:29:24 -0800 Andrew Morton wrote:

> "Randy.Dunlap" <rdunlap@xenotime.net> wrote:
> >
> > From: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > Link scsi-debug driver after SATA so that scsi-debug does not
> > interfere with real SCSI device ordering.
> > Yes, I was bitten by this.
> > 
> 
> What does "bitten" mean?

It means that I got the usual "VFS: could not find root filesystem on
device (8,8)"  (or however it is spelled).
Oh, and that I had to add netconsole to see what was causing it,
but that is easy enough to do.

> Is this a regression?

It's probably been like this ever since SATA was added (libata)
and only happens if SCSI_DEBUG=y (so I changed it to =m).
I can't say that it's a regression since this occurred on a new
machine.

> If so, relative to which release?
> 
> Potentially this sort of thing can have serious effects.  Like, non-booting
> machines.  Is that the case here?

Yes, it was.

> Is this 2.6.16 material?

Well... I would say yes, I don't think it's too risky for that.

> Stuff like that, thanks.

OK, I'll try to be more verbose in the future (on patches).

---
~Randy
