From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: An MCA ESP driver
Date: Sat, 5 Jan 2008 14:53:32 -0700
Message-ID: <20080105215331.GK20473@parisc-linux.org>
References: <20070806232458.GC9732@parisc-linux.org> <20070807.002604.78735512.davem@davemloft.net> <20070815172600.GF16277@parisc-linux.org> <20070815.145551.78731552.davem@davemloft.net> <1199567892.3399.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42749 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653AbYAEVxd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 16:53:33 -0500
Content-Disposition: inline
In-Reply-To: <1199567892.3399.32.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org

On Sat, Jan 05, 2008 at 03:18:12PM -0600, James Bottomley wrote:
> Just a check up on this:  Matthew were you ever going to complete the
> mca_94x conversion?  It's quite topical because it would be another
> example driver for the m68k people to look at.
> 
> If not, I can probably complete the bits you haven't yet done, but it
> would be nice to know.

I wasn't planning on completing the conversion, no.  I don't have the
hardware myself, so can't test it.  I started working on it when I was
between jobs, and once I found gainful employment, the amount of free
time I have to hack on obscure hardware that I don't have declined to
nil ;-)

Thanks for volunteering to complete the conversion.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
