From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/2] sd: Refactor sd_read_capacity()
Date: Fri, 13 Mar 2009 19:19:15 -0600
Message-ID: <20090314011915.GD14127@parisc-linux.org>
References: <1236882030-27964-1-git-send-email-willy@linux.intel.com> <1236882030-27964-2-git-send-email-willy@linux.intel.com> <1236979776.31764.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37718 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbZCNBTe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2009 21:19:34 -0400
Content-Disposition: inline
In-Reply-To: <1236979776.31764.2.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org

On Fri, Mar 13, 2009 at 04:29:36PM -0500, James Bottomley wrote:
> On Thu, 2009-03-12 at 14:20 -0400, Matthew Wilcox wrote:
> > +#define RC16_LEN 13
> 
> Shouldn't this be 32, the defined length of a READ CAPACITY 16 return?
> 
> In theory asking for less is fine, since the spec allows it, but it's
> setting a trap for expanded users of READ_CAPACITY 16 since they might
> blindly use a buffer[13] or beyond, not realising we didn't actually ask
> for data beyond buffer[12].

I'm perfectly fine with expanding it to 16 or even 32.  Want me to
repost the patch, or will you fix it up?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
