From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Fri, 01 Jul 2011 15:29:08 -0500
Message-ID: <1309552148.2722.46.camel@mulgrave>
References: <20110701170531.GA3693@tassilo.jf.intel.com>
	 <20110701181406.GA1614@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110701181406.GA1614@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, rjw@sisk.pl, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-07-01 at 14:14 -0400, Dave Jones wrote:
> On Fri, Jul 01, 2011 at 10:05:31AM -0700, Andi Kleen wrote:
> 
>  > I found I can reliably crash a 3.0 system by pulling the
>  > USB cable of a mounted USB cdrom (or rather a USB device which
>  > has a builtin fake CD-ROM) 
>  > 
>  > I suspect it's a regression too.
> 
> We've been seeing a lot of similar bugs in Fedora since we pushed
> a 2.6.38.8 update.  Some of the traces are different, but some
> look to be the same as yours. (here's one for eg: https://bugzilla.redhat.com/show_bug.cgi?id=712830)
> 
> The common cause seems to be 'device went away'. So USB CD drives,
> USB memory sticks, and for some reason virtualbox shutdown.

I think it's something specific in the USB path.  I can't reproduce on
3.0-rc5 with a SATA DVD hot unplug.  USB cc's added.

James
