From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: git-acpi breakage, sym2
Date: Fri, 12 May 2006 05:40:46 -0600
Message-ID: <20060512114046.GO12272@parisc-linux.org>
References: <20060511231005.0bce3384.akpm@osdl.org> <20060512112345.GM12272@parisc-linux.org> <20060512042504.33b1ad20.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43244 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1751241AbWELLkr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 07:40:47 -0400
Content-Disposition: inline
In-Reply-To: <20060512042504.33b1ad20.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-acpi@vger.kernel.org, len.brown@intel.com, linux-scsi@vger.kernel.org, willy@debian.org

On Fri, May 12, 2006 at 04:25:04AM -0700, Andrew Morton wrote:
> Matthew Wilcox <matthew@wil.cx> wrote:
> > > scsi0 : sym-2.2.3
> > >  0:0:0:0: ABORT operation started.
> > >  0:0:1:0: ABORT operation started.
> > >  0:0:2:0: ABORT operation started.
> > > 
> > > ad infinitum.  How come?
> > 
> > Are you sure it's ad infinitum or just once for every device?
> 
> I have a single card talking to a single disk.  I whacked it after a couple
> of minutes.

Sure, but it has to probe each device to find out it's not there.  See
the target number increasing in the snippet I left above?

> > Anyway, this looks like a fairly classic "sym2 isn't getting any
> > interrupts" scenario.
> 
> It is - Len found that one.

Cool.  I'd love sym2 to behave more sanely in the 'no interrupts' case
because it means I get a lot of bug reports directed my way from people
with bad setups.  I don't see a nice way to do it though ...
