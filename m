From: bloch@verdurin.com
Subject: Re: Very slow writes with mptsas
Date: Thu, 7 Jun 2007 22:42:32 +0100
Message-ID: <20070607214229.GG6519@bloch.config>
References: <20070605161620.GB6519@bloch.config> <7579f7fb0706052232x44db1f7he88a50646a3c57db@mail.gmail.com> <4666F7A0.8080605@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 87-194-8-112.bethere.co.uk ([87.194.8.112]:53864 "EHLO
	bloch.config" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753575AbXFGVmp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jun 2007 17:42:45 -0400
Content-Disposition: inline
In-Reply-To: <4666F7A0.8080605@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Matthew Jacob <lydianconcepts@gmail.com>, linux-scsi@vger.kernel.org, linux-precision@dell.com

On Wed, 06 Jun 2007, Douglas Gilbert wrote:

> Matthew Jacob wrote:
> > The FreeBSD problem was fixed by Scott Long a couple of days ago by
> > doing some cut through SAS stuff that enabled Write Cache for SATA
> > drives. Why LSI-Logic couldn't just blitheringly synthesize mode page
> > 8 is beyond me, but okay.
> > 
> > I dunno whether the issue here is the same one Scott tackled- probably
> > given the messages. Eric- you listening in on this?
> 
> Matt,
> Just in case Eric doesn't answer, I suspect if the
> HBA firmware can be upgraded (from Dell or LSI?) then
> WCE (write cache enable) in the caching mode page
> will be supported. It is one of the few mode page
> settings that is required to be implemented in SAT.
> 
> The other field that should be changeable is DRA
> (disable read ahead). Both work on my LSI SAS HBA.
> 
> Doug Gilbert
> 

I upgraded to the latest Dell firmware, but the kernel message is the
same - write cache disabled, and the write speed is still very bad.  No
sign of new changeable options.

Can't actually see any firmware on the LSI site.

Adam
