From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] esp: tidy up target reference counting
Date: Tue, 24 Jun 2008 13:36:43 -0700 (PDT)
Message-ID: <20080624.133643.160100520.davem@davemloft.net>
References: <1214250729.3310.24.camel@localhost.localdomain>
	<20080623.145828.60746793.davem@davemloft.net>
	<1214324884.3299.63.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55428
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753723AbYFXUgn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2008 16:36:43 -0400
In-Reply-To: <1214324884.3299.63.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Tue, 24 Jun 2008 11:28:04 -0500

> On Mon, 2008-06-23 at 14:58 -0700, David Miller wrote:
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Date: Mon, 23 Jun 2008 14:52:09 -0500
> > 
> > > The esp driver currently does hand rolled reference counting of its
> > > target.  It's much easier to do what it needs to do if it's plugged into
> > > the mid-layer callbacks (target_alloc and target_destroy) which were
> > > designed for this case, so do it this way and get rid of the internal
> > > target reference count.
> > > 
> > > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > 
> > Much cleaner, thanks!
> > 
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> You're welcome ... I actually initially queued this for the merge
> window, but since this looks like it fixes a bug that would affect any
> multi-lun installation, isn't it a candidate for the current git head
> (and indeed for stable), or isn't there that much of a multi-lun install
> base with this driver to worry about?

I think you should push these fixes to current (and -stable).
