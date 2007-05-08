From: David Miller <davem@davemloft.net>
Subject: Re: [patch 16/30] drivers/scsi/aic7xxx_old: Convert to generic
 boolean-values
Date: Tue, 08 May 2007 14:44:45 -0700 (PDT)
Message-ID: <20070508.144445.88474913.davem@davemloft.net>
References: <20070508121411.d187a648.akpm@linux-foundation.org>
	<1178652273.3737.67.camel@mulgrave.il.steeleye.com>
	<20070508131152.0003b770.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58702
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S967821AbXEHVop (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 17:44:45 -0400
In-Reply-To: <20070508131152.0003b770.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, ricknu-0@student.ltu.se

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 8 May 2007 13:11:52 -0700

> On Tue, 08 May 2007 14:24:32 -0500
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > However, could we compromise and just add TRUE = true, FALSE = false to
> > the enum?
> 
> That sounds sane.  But I don't recall all the details of the discussion
> and perhaps I'm missing something.
> 
> I think the whole bool/true/false thing is pretty dissatisfactory really. 
> Java gets this right and C cannot and will not and we end up with people
> using true and false as plain old "1" and "0".

I think it's more important to be consistent across the entire tree,
whatever we choose, than to be "nice" and add compat define hacks for
the sake of a select few stubborn drivers.

If you're going to add those ugly "#define TRUE true" bits, the whole
point of the change is lost so you might as not make it at all.
