From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH] sysfs: add filter function to groups
Date: Wed, 31 Oct 2007 13:19:47 +0100
Message-ID: <20071031131947.35a521c9@gondolin.boeblingen.de.ibm.com>
References: <1193671019.3383.13.camel@localhost.localdomain>
	<1193676852.2655.21.camel@lov.site>
	<1193677071.3383.56.camel@localhost.localdomain>
	<47261F50.3050901@s5r6.in-berlin.de>
	<1193768743.3321.91.camel@localhost.localdomain>
	<20071031035506.GH14910@kroah.com>
	<20071031104103.13e07d8f@gondolin.boeblingen.de.ibm.com>
	<47285063.1040508@s5r6.in-berlin.de>
	<20071031112039.0b067ce3@gondolin.boeblingen.de.ibm.com>
	<47285AF0.1010900@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:16254 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780AbXJaMUj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 08:20:39 -0400
In-Reply-To: <47285AF0.1010900@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@SteelEye.com>, Kay Sievers <kay.sievers@vrfy.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, 31 Oct 2007 11:37:36 +0100,
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> > mask_out() would also imply that the common use case is to have all
> > attributes in the group created and that you need to take action to
> > have an attribute not created.
> 
> Here you have a point.  But James has a point too when he says:
> | We basically want to show capability by which file is present.

Currently, if you register an attribute group, all of the attributes
will show up. I find it more intuitive to have to block some attributes
explicitely if I want to have more control, but the original logic is
fine with me as well, if most people prefer that :)

> Anyway, /if/ the reverse logic is preferred, it shouldn't be called
> "mask_out()" but rather "is_masked()" or "is_hidden()" or the like.

Sure. is_masked() would be fine.

