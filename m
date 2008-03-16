From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: new kernel oops in recent kernels
Date: Sun, 16 Mar 2008 13:47:50 -0500
Message-ID: <1205693270.6767.99.camel@localhost.localdomain>
References: <1205680748.3050.29.camel@localhost>
	 <1205685580.6767.87.camel@localhost.localdomain>
	 <1205692360.5470.6.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35424 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbYCPSry (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Mar 2008 14:47:54 -0400
In-Reply-To: <1205692360.5470.6.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giuseppe Sacco <giuseppe@eppesuigoccas.homedns.org>
Cc: linux-scsi@vger.kernel.org

On Sun, 2008-03-16 at 19:32 +0100, Giuseppe Sacco wrote:
> Hi James,
> 
> Il giorno dom, 16/03/2008 alle 11.39 -0500, James Bottomley ha scritto:
> > On Sun, 2008-03-16 at 16:19 +0100, Giuseppe Sacco wrote:
> [...]
> > This is a bit strange.  It's obviously O2 specific, which makes it a lot
> > harder.  Can you compile the kernel with CONFIG_DEBUG_INFO and reproduce
> > (just in case this changes the symbol layout).  Then ask gdb where
> [...]
> 
> I cannot find any CONFIG_DEBUG_INFO. Do you mean CONFIG_DEBUG_KERNEL?

This from lib/Kconfig.debug:

config DEBUG_INFO
        bool "Compile the kernel with debug info"
        depends on DEBUG_KERNEL
        help
          If you say Y here the resulting kernel image will include
          debugging info resulting in a larger kernel image.
          This adds debug symbols to the kernel and modules (gcc -g), and
          is needed if you intend to use kernel crashdump or binary object
          tools like crash, kgdb, LKCD, gdb, etc on the kernel.
          Say Y here only if you plan to debug the kernel.

          If unsure, say N.

It does depend on CONFIG_DEBUG_KERNEL according to the depends clause.

James


