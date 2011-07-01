From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Fri, 1 Jul 2011 20:32:27 +0200
Message-ID: <20110701183227.GF23059@one.firstfloor.org>
References: <20110701170531.GA3693@tassilo.jf.intel.com> <20110701181406.GA1614@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110701181406.GA1614@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, rjw@sisk.pl
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 01, 2011 at 02:14:06PM -0400, Dave Jones wrote:
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

I've also seen one with an earlier kernel where the NULL 
reference was in elv_.* something.  Don't have a written down backtrace
for this, but perhaps you have.

-Andi
