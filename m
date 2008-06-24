From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] esp: tidy up target reference counting
Date: Tue, 24 Jun 2008 11:28:04 -0500
Message-ID: <1214324884.3299.63.camel@localhost.localdomain>
References: <1214250729.3310.24.camel@localhost.localdomain>
	 <20080623.145828.60746793.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50044 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751641AbYFXQ2I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2008 12:28:08 -0400
In-Reply-To: <20080623.145828.60746793.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-06-23 at 14:58 -0700, David Miller wrote:
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Mon, 23 Jun 2008 14:52:09 -0500
> 
> > The esp driver currently does hand rolled reference counting of its
> > target.  It's much easier to do what it needs to do if it's plugged into
> > the mid-layer callbacks (target_alloc and target_destroy) which were
> > designed for this case, so do it this way and get rid of the internal
> > target reference count.
> > 
> > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> Much cleaner, thanks!
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

You're welcome ... I actually initially queued this for the merge
window, but since this looks like it fixes a bug that would affect any
multi-lun installation, isn't it a candidate for the current git head
(and indeed for stable), or isn't there that much of a multi-lun install
base with this driver to worry about?

James


