From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 21/21] advansys: Changes to work on parisc
Date: Tue, 2 Oct 2007 21:00:39 -0600
Message-ID: <20071003030039.GE12049@parisc-linux.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765432770-git-send-email-matthew@wil.cx> <4702F7B2.7080600@garzik.org> <20071003021545.GD12049@parisc-linux.org> <4702FE4D.4030603@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53902 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbXJCDAm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 23:00:42 -0400
Content-Disposition: inline
In-Reply-To: <4702FE4D.4030603@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Tue, Oct 02, 2007 at 10:28:29PM -0400, Jeff Garzik wrote:
> Incorrect.  That is highly platform specific, with many using unsigned 
> long, since the [non-x86] platform is generally pointing to a special 
> memory region rather than directly using an x86-like instruction.
> 
> unsigned long is the portable size to use, because it is guaranteed to 
> work on all platforms.
> 
> unsigned int means you exclude powerpc[64], alpha, sparc64, sh, ... 
> it's not portable, unlike unsigned long.

I don't think that's true.  I asked a powerpc64 person about it the
other day, and he said they don't use anything beyond the lower 32 bits.

If people are really supposed to use unsigned long, it would make sense
to get the i386 macros changed, since they are canonical.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
