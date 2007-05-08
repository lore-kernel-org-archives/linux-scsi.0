From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 16/30] drivers/scsi/aic7xxx_old: Convert to generic
	boolean-values
Date: Tue, 08 May 2007 16:59:04 -0500
Message-ID: <1178661544.3737.98.camel@mulgrave.il.steeleye.com>
References: <20070508121411.d187a648.akpm@linux-foundation.org>
	 <1178652273.3737.67.camel@mulgrave.il.steeleye.com>
	 <20070508131152.0003b770.akpm@linux-foundation.org>
	 <20070508.144445.88474913.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56517 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968266AbXEHV7L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 17:59:11 -0400
In-Reply-To: <20070508.144445.88474913.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, ricknu-0@student.ltu.se

On Tue, 2007-05-08 at 14:44 -0700, David Miller wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Tue, 8 May 2007 13:11:52 -0700
> 
> > On Tue, 08 May 2007 14:24:32 -0500
> > James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > 
> > > However, could we compromise and just add TRUE = true, FALSE = false to
> > > the enum?
> > 
> > That sounds sane.  But I don't recall all the details of the discussion
> > and perhaps I'm missing something.
> > 
> > I think the whole bool/true/false thing is pretty dissatisfactory really. 
> > Java gets this right and C cannot and will not and we end up with people
> > using true and false as plain old "1" and "0".

In that case, I think we go with what's there, which seems to be
predominantly TRUE/FALSE.

> I think it's more important to be consistent across the entire tree,
> whatever we choose, than to be "nice" and add compat define hacks for
> the sake of a select few stubborn drivers.
> 
> If you're going to add those ugly "#define TRUE true" bits, the whole
> point of the change is lost so you might as not make it at all.

That too wouldn't be an unacceptable outcome ...

James


