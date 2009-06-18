From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] tmscsim: Fix big left-shifts of unsigned char
Date: Thu, 18 Jun 2009 08:55:38 -0600
Message-ID: <20090618145538.GC19977@parisc-linux.org>
References: <4A3A2FA2.60005@gmail.com> <1245330204.4773.10.camel@mulgrave.site> <20090618131632.GZ19977@parisc-linux.org> <4A3A40C9.9020900@panasas.com> <20090618133613.GA19977@parisc-linux.org> <1245336342.7586.4.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54521 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbZFROzg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2009 10:55:36 -0400
Content-Disposition: inline
In-Reply-To: <1245336342.7586.4.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Roel Kluin <roel.kluin@gmail.com>, garloff@suse.de, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Thu, Jun 18, 2009 at 02:45:42PM +0000, James Bottomley wrote:
> On Thu, 2009-06-18 at 07:36 -0600, Matthew Wilcox wrote:
> > For one, Linux doesn't support an ILP64 model.  I32LP64 and ILP32 are
> > the only two models supported.
> 
> Heh ... embedded is easy to forget.  I believe, for reasons I have had
> explained at length but understandably don't wish to go through again,
> Sony has an IP32L64 model for the PS3 which causes all sorts of erm
> problems.

And they compile the kernel in that mode?  I'd not heard of that before.
Not that it makes any difference to this case ... but I suppose we
mostly assume that a pointer fits in an unsigned long, and rarely assume
vice-versa.

I know Windows supports an IL32P64 mode, and IRIX had an ILP64 mode,
but this is the first I've heard of an IP32L64 mode.  There's no limits
to the craziness some people will do, I suppose.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
