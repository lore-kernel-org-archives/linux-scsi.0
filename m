From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] fix for Incorrect number of segments after building	list problem
Date: Thu, 21 Oct 2004 15:02:19 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041021130218.GL10531@suse.de>
References: <1097790683.1717.47.camel@mulgrave> <20041020143940.GK10531@suse.de> <20041020150708.GN10531@suse.de> <1098287481.2008.6.camel@mulgrave> <20041020155825.GP10531@suse.de> <1098288465.2008.13.camel@mulgrave> <4176A448.5040508@pobox.com> <20041020174752.GT10531@suse.de> <1098362947.1777.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:4534 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266679AbUJUNDC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 09:03:02 -0400
Content-Disposition: inline
In-Reply-To: <1098362947.1777.1.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, 'Dave Olien' <dmo@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Oct 21 2004, James Bottomley wrote:
> On Wed, 2004-10-20 at 13:47, Jens Axboe wrote:
> > On Wed, Oct 20 2004, Jeff Garzik wrote:
> > > Clearly we need to remedy this :)
> 
> Shamelessly beg for hardware?  Moi?  How well^Wlittle you know me.

Hehe

> > By improving James' imagination? :)
> 
> I meant that 50% of the fix is pulling out the hacks that permeate the
> IDE drivers to resplit SG lists after iommu merging.  That's the bit I
> can't test.

That's true. But you could set the same limits for SCSI, and check in
init_io() whether those limits are violated.

But I should shut up, I don't want to ruin your chance at free hardware.
SCSI whore gone SATA, so sad :)

-- 
Jens Axboe

