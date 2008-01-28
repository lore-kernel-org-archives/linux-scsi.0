From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] zfcp: fix sense_buffer access bug
Date: Mon, 28 Jan 2008 07:53:52 -0500
Message-ID: <1201524832.3105.5.camel@localhost.localdomain>
References: <20080127124124H.tomof@acm.org>
	 <20080128074624.GA4622@schmichrtp.de.ibm.com>
	 <20080128182912W.fujita.tomonori@lab.ntt.co.jp>
	 <20080128100446.GA4732@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51369 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753301AbYA1MyL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jan 2008 07:54:11 -0500
In-Reply-To: <20080128100446.GA4732@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org, linux-scsi@vger.kernel.org


On Mon, 2008-01-28 at 11:04 +0100, Christof Schmitt wrote:
> On Mon, Jan 28, 2008 at 06:29:12PM +0900, FUJITA Tomonori wrote:
> > > ACK for fixing the access to the sense buffer.
> > > 
> > > We are working internally on cleaning up the zfcp messages. With this
> > > change, the 'trace' and 'hex dump' messages will disappear. So, could
> > > you simply remove the ZFCP_HEX_DUMP message above, instead of fixing
> > > it?
> > 
> > I can but James has already merged the above patch to scsi-misc. So it
> > would be more convenient for everyone if you could rebase your
> > patchset on top of scsi-misc?
> 
> Ok, if the pach is already merged, i am fine with that. We will have
> to rebase the patches we are working on anyway. Thanks for providing
> the fix.

It's in my upstream tree, but not merged with Linus and I can easily
rebase.  However, it is a critical bug fix, without it the driver will
likely oops from overwriting command structures, so I'd rather keep it
separate from any cleanup patches.

James


