From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: State Model for scsi device badness PATCH
Date: Thu, 20 Nov 2003 18:37:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031121023740.GA1150@beaverton.ibm.com>
References: <20031120190105.7456.qmail@web13007.mail.yahoo.com> <1069354978.1770.221.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:50375 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S264235AbTKUCdV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 21:33:21 -0500
Content-Disposition: inline
In-Reply-To: <1069354978.1770.221.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Amit Patel <patelamitv@yahoo.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> On Thu, 2003-11-20 at 13:01, Amit Patel wrote:
> > I just walked through some of the code and I could
> > work around the badness problem by not doing
> > get_device if the scsi device is not in running state
> > yet. I have attached the patch for scsi_lib.c where I
> > do not call get_device if the state is not
> > SDEV_RUNNING and similarly do not do put_device if you
> > have not done get_device because of the device state.
> 
> Ah, I'm sorry, warning light goes off.
> 
> The patch is designed to operate on top of Mike Anderson's rework of our
> device initialisation code.
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=106810957502435&w=2
> 
> The get_device in the request function causes the badness without this
> other patch.
> 
> Mike hasn't yet posted an update (hey, this is a hint, Mike) otherwise I
> would already have folded it into the bugfixes tree.
> 

Got the hint :-).

I will re-roll tonight.

-andmike
--
Michael Anderson
andmike@us.ibm.com

