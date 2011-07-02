From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sat, 2 Jul 2011 08:38:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107020837220.11097-100000@netrider.rowland.org>
References: <20110702060846.GH23059@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110702060846.GH23059@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, rjw@sisk.pl, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2 Jul 2011, Andi Kleen wrote:

> > I'm not able to reproduce it on a vanilla 3.0-rc5 system.  Can anybody
> > give the exact sequence of steps you went through to trigger the bug?
> 
> Connect USB storage device with builtin fake CD rom. Wait for udisk
> to mount it. Pull cable. udisk does umount. Oops.
> 
> I also got a log of the refcounting now if you want it.

Yes, please.  The excerpt that James posted isn't enough.  In 
particular, it doesn't show what happens during device creation.

Alan Stern
