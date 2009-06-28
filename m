From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] bnx2i remove not so useful global variable
 bnx2i_reg_devices
Date: Sun, 28 Jun 2009 12:25:22 -0500
Message-ID: <1246209922.4190.14.camel@mulgrave.site>
References: <C27F8246C663564A84BB7AB343977242178EE7808C@IRVEXCHCCR01.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49787 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbZF1RZW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Jun 2009 13:25:22 -0400
In-Reply-To: <C27F8246C663564A84BB7AB343977242178EE7808C@IRVEXCHCCR01.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Chan <mchan@broadcom.com>
Cc: Anil Veerabhadrappa <anilgv@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>

On Sun, 2009-06-28 at 08:46 -0700, Michael Chan wrote:
> James Bottomley wrote:
> 
> > On Tue, 2009-06-23 at 18:11 -0700, Anil Veerabhadrappa wrote:
> > > >From a8267738e9ca5c73ad6c0d89f17cf864bfc908c8 Mon Sep 17
> > 00:00:00 2001
> > > From: Anil Veerabhadrappa <anilgv@broadcom.com>
> > > Date: Tue, 23 Jun 2009 13:56:29 -0700
> > > Subject: [PATCH]     bnx2i - remove global variable
> > bnx2i_reg_devices
> > >
> > >     * Removed bnx2i_reg_devices as this counter is not really
> > >       used in a meaningful way
> > >     Cc: Mike Christie <michaelc@cs.wisc.edu>
> > >
> > > Signed-off-by: Michael Chan <mchan@broadcom.com>
> > > Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
> >
> > Tell me what these signoffs mean:  The first signoff by Michael Chan
> > implies it's his patch, but it has your authorship information.
> >
> 
> Sorry, Anil should have put his signoff first.  Do we need to re-spin
> the pacthes?

So did you actually contribute to these?  In which case a note saying
something like 

[mchan: did X to the driver]

is useful ... otherwise if you're just confirming as maintainer it
should be acked-by (unless you send me the patches yourself).

James


