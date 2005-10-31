From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: oops with USB Storage on 2.6.14
Date: Mon, 31 Oct 2005 11:14:13 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0510311055270.13355-100000@iolanthe.rowland.org>
References: <20051030170244.4a8c06b7.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:65436 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932432AbVJaQOR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 11:14:17 -0500
In-Reply-To: <20051030170244.4a8c06b7.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Masanari Iida <standby24x7@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, Kernel development list <linux-kernel@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Sun, 30 Oct 2005, Andrew Morton wrote:

> Masanari Iida <standby24x7@gmail.com> wrote:

> > Hello Andrew,
> > 
> > I did disabled CONFIG_DEBUG_PAGEALLOC and re-tested on 2.6.14-rc1.
> > Now the oops didn't happen when I connect digital camera to the USB.
> 
> So the first oops was probably use-after-free.
> 
> > I could mount the camera as USB storage.
> > But oops still happen when I turned the camera power off.
> > (This oops didn't halt my system, BTW)
> > 
> > # Unable to handle kernel paging request at virtual address 6b6b6bb3
> >   printing eip:
> > c02b88ca
> > *pde = 00000000
> > Oops: 0002 [#1]
> > SMP
> > Modules linked in: autofs e100 ipt_LOG ipt_state ip_conntrack
> > ipt_recent iptable_filter ip_tables video rtc
> > CPU:    0
> > EIP:    0060:[<c02b88ca>]    Not tainted VLI
> > EFLAGS: 00010296   (2.6.14-rc1)
> > EIP is at scsi_remove_device+0x3a/0x50

> > If you need some more test, let me know.
> > In that case, please specify which version of kernel you want me to test.
> > 
> 
> OK, thanks.  This is a different bug.  Presumably in USB.

This was fixed in later releases of 2.6.14-rc.

I wasn't able to reproduce the original problem, even after setting 
CONFIG_DEBUG_PAGEALLOC.

Alan Stern

