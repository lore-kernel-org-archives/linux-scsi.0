From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.25-rc1
Date: Wed, 13 Feb 2008 20:10:53 -0600
Message-ID: <1202955053.3109.104.camel@localhost.localdomain>
References: <1202947364.3109.96.camel@localhost.localdomain>
	 <20080213161643.65a5a779.akpm@linux-foundation.org>
	 <1202951513.3109.101.camel@localhost.localdomain>
	 <20080213.172251.249294145.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60445 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751683AbYBNCK7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 21:10:59 -0500
In-Reply-To: <20080213.172251.249294145.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


On Wed, 2008-02-13 at 17:22 -0800, David Miller wrote:
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Wed, 13 Feb 2008 19:11:53 -0600
> 
> > 
> > On Wed, 2008-02-13 at 16:16 -0800, Andrew Morton wrote:
> > > kill-warnings-in-mptbaseh-on-parisc64.patch
> > 
> > >   Warning fixes.
> > 
> > Not sure ... LSI is supposed to be processing this.
> 
> James, please don't push build warning fixes and the like back to the
> driver maintainers.
> 
> This is your domain as SCSI maintainer, and you should integrate these
> kinds of things directly and as promptly as possible.
> 
> This is doubly true if the "driver maintainer" can't be bothered
> to ACK or fixup the patch for months.
> 
> Otherwise this kind of stuff rots, and diligent people like Andrew
> (and the patch submitter, whoever that might be) get extremely
> frustrated.

LSI did ask to merge through their patch process, but I agree this one's
been hanging around for a bit long.

James


