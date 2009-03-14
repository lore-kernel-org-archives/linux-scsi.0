From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] sd: Refactor sd_read_capacity()
Date: Sat, 14 Mar 2009 08:40:18 -0500
Message-ID: <1237038018.3907.8.camel@localhost.localdomain>
References: <1236882030-27964-1-git-send-email-willy@linux.intel.com>
	 <1236882030-27964-2-git-send-email-willy@linux.intel.com>
	 <1236979776.31764.2.camel@localhost.localdomain>
	 <20090314011915.GD14127@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40236 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753441AbZCNNkX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Mar 2009 09:40:23 -0400
In-Reply-To: <20090314011915.GD14127@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org

On Fri, 2009-03-13 at 19:19 -0600, Matthew Wilcox wrote:
> On Fri, Mar 13, 2009 at 04:29:36PM -0500, James Bottomley wrote:
> > On Thu, 2009-03-12 at 14:20 -0400, Matthew Wilcox wrote:
> > > +#define RC16_LEN 13
> > 
> > Shouldn't this be 32, the defined length of a READ CAPACITY 16 return?
> > 
> > In theory asking for less is fine, since the spec allows it, but it's
> > setting a trap for expanded users of READ_CAPACITY 16 since they might
> > blindly use a buffer[13] or beyond, not realising we didn't actually ask
> > for data beyond buffer[12].
> 
> I'm perfectly fine with expanding it to 16 or even 32.  Want me to
> repost the patch, or will you fix it up?

It's a one liner ... I can do it (crosses fingers).

James


