From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/3] pluto/fc - Enable compilation for all ARCHs
Date: Mon, 15 Oct 2007 12:39:28 -0600
Message-ID: <20071015183928.GF25488@parisc-linux.org>
References: <4713A175.9020408@panasas.com> <4713A2DB.2000302@panasas.com> <20071015180949.GC25488@parisc-linux.org> <4713AEF0.5070706@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47149 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933937AbXJOSjd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 14:39:33 -0400
Content-Disposition: inline
In-Reply-To: <4713AEF0.5070706@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "David S. Miller" <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>

On Mon, Oct 15, 2007 at 08:18:24PM +0200, Boaz Harrosh wrote:
> This is all new territory for me. But CONFIG_SCSI_PLUTO is dependent on
> SCSI and fc.c is not the real driver just the needed bits from the sparc
> side. So the code mess calls for a Kconfig mess, I guess.

I've spent a lot of time looking at pluto/fc4 recently.  And I'm very
much still in a 'wtf' mode.  Pluto creates a new scsi *host* for every
Sun Storage Array proessor *device* on the SCSI bus.  I have no clue
why it does this.

I'm sure there's a sane sensible driver or three trying to get out from
inside the pluto/soc/socal/fc4 maze, but I'm not quite sure what form
it should take.

Dave, can you explain what's going on?  I really want to help this
driver fit the current scsi model better, but I don't understand
what it's trying to do.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
