From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sat, 2 Jul 2011 08:08:46 +0200
Message-ID: <20110702060846.GH23059@one.firstfloor.org>
References: <1309554818.2722.48.camel@mulgrave> <Pine.LNX.4.44L0.1107012200260.4273-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107012200260.4273-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, rjw@sisk.pl, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> I'm not able to reproduce it on a vanilla 3.0-rc5 system.  Can anybody
> give the exact sequence of steps you went through to trigger the bug?

Connect USB storage device with builtin fake CD rom. Wait for udisk
to mount it. Pull cable. udisk does umount. Oops.

I also got a log of the refcounting now if you want it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
