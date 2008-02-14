From: David Miller <davem@davemloft.net>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.25-rc1
Date: Wed, 13 Feb 2008 17:22:51 -0800 (PST)
Message-ID: <20080213.172251.249294145.davem@davemloft.net>
References: <1202947364.3109.96.camel@localhost.localdomain>
	<20080213161643.65a5a779.akpm@linux-foundation.org>
	<1202951513.3109.101.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934819AbYBNBWd@vger.kernel.org>
In-Reply-To: <1202951513.3109.101.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Wed, 13 Feb 2008 19:11:53 -0600

> 
> On Wed, 2008-02-13 at 16:16 -0800, Andrew Morton wrote:
> > kill-warnings-in-mptbaseh-on-parisc64.patch
> 
> >   Warning fixes.
> 
> Not sure ... LSI is supposed to be processing this.

James, please don't push build warning fixes and the like back to the
driver maintainers.

This is your domain as SCSI maintainer, and you should integrate these
kinds of things directly and as promptly as possible.

This is doubly true if the "driver maintainer" can't be bothered
to ACK or fixup the patch for months.

Otherwise this kind of stuff rots, and diligent people like Andrew
(and the patch submitter, whoever that might be) get extremely
frustrated.
