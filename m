From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] sym53c8xx module parameter passing not working (2.5.6)
Date: Fri, 08 Oct 2004 12:29:16 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097202556.9363.16.camel@localhost.localdomain>
References: <7AAD212492598A4A92463C3F5D34C54F194EDC@ccd3.CC.de>
	 <20041001162939.A4215@infradead.org>
	 <20041001165555.GF16153@parcelfarce.linux.theplanet.co.uk>
	 <20041008013029.GM16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:62935 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S267521AbUJHC3U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2004 22:29:20 -0400
In-Reply-To: <20041008013029.GM16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, "Heinzmann, Robert" <Heinzmann@cc-dresden.de>, linux-scsi@vger.kernel.org

On Fri, 2004-10-08 at 11:30, Matthew Wilcox wrote:
> On Fri, Oct 01, 2004 at 05:55:55PM +0100, Matthew Wilcox wrote:
> to allow people to switch over.  But when I try this, I get:
> 
> sym53c8xx: Unknown parameter `hostid'
> sym53c8xx: Ignoring new-style parameters in presence of obsolete ones
> 
> It'd be nice to be able to use either for a while.  Rusty, is there any
> chance of allowing this?

Well, it'd never be neat.  I'd rather encourage migration: in 2.6.10 I
will start my jihad on MODULE_PARM, ideally finished before 2.6.11. 

It's usually better that someone who knows the code does the transition
(you can often do better than a naive substitution), so my first step
might be to clean up Linus' compile, then make MODULE_PARM warn, to
encourage people to help.

Rusty.
-- 
Anyone who quotes me in their signature is an idiot -- Rusty Russell

