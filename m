From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix for Incorrect number of segments after
	building	list problem
Date: 21 Oct 2004 08:49:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098362947.1777.1.camel@mulgrave>
References: <1097790683.1717.47.camel@mulgrave>
	<20041020143940.GK10531@suse.de> <20041020150708.GN10531@suse.de>
	<1098287481.2008.6.camel@mulgrave> <20041020155825.GP10531@suse.de>
	<1098288465.2008.13.camel@mulgrave> <4176A448.5040508@pobox.com>
	<20041020174752.GT10531@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:37547 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268766AbUJUMtb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 08:49:31 -0400
In-Reply-To: <20041020174752.GT10531@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, 'Dave Olien' <dmo@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-10-20 at 13:47, Jens Axboe wrote:
> On Wed, Oct 20 2004, Jeff Garzik wrote:
> > Clearly we need to remedy this :)

Shamelessly beg for hardware?  Moi?  How well^Wlittle you know me.

> By improving James' imagination? :)

I meant that 50% of the fix is pulling out the hacks that permeate the
IDE drivers to resplit SG lists after iommu merging.  That's the bit I
can't test.

James


