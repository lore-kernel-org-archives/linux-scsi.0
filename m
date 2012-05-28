From: Eldad Zack <eldadzack@gmail.com>
Subject: Re: 3.4.0-02580-g72c04af regression on sparc64 - partitions not
 recognized
Date: Mon, 28 May 2012 18:46:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1205281835400.32511@debianer>
References: <Pine.LNX.4.44L0.1205251034190.1907-100000@iolanthe.rowland.org> <201205252127.21436.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201205252127.21436.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <jejbbe@hansenpartnership.com>, Dan Williams <dan.j.williams@intel.com>, David Miller <davem@davemloft.net>, mroos@linux.ee, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
List-Id: linux-scsi@vger.kernel.org


On Fri, 25 May 2012, Rafael J. Wysocki wrote:
> On Friday, May 25, 2012, Alan Stern wrote:
> > On Fri, 25 May 2012, James Bottomley wrote:
> > 
> > Whether or not the boot kernel can have modular drivers isn't clear to me;
> 
> It can, but then the code in question is irrelevant and the resume has to
> be triggered in a different way.  For example, by writing to
> /sys/power/resume from the initrd boot scripts.
> 
> > I don't know when the check for a valid image in the swap area is carried
> > out in relation to starting up the initramfs task.
> 
> This particular one is carried out before the initrd is loaded.

I just got hit by this one too, but on x86 qemu. There's no initrd, and all
the modules are built in.

With commit a7a20d103994fd760766e6c9d494daa569cbfe06 the kernel doesn't 
get to the point where it reads the partition table.

If it's of any help, I can provide more details.

Eldad
