From: "Michael Chan" <mchan@broadcom.com>
Subject: Re: [PATCH 1/3] bnx2i remove not so useful global variable
 bnx2i_reg_devices
Date: Sun, 28 Jun 2009 12:59:24 -0700
Message-ID: <1246219164.839.31.camel@nseg_linux_HP1.broadcom.com>
References: <C27F8246C663564A84BB7AB343977242178EE7808C@IRVEXCHCCR01.corp.ad.broadcom.com>
 <1246209922.4190.14.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4691 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbZF1UGj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Jun 2009 16:06:39 -0400
In-Reply-To: <1246209922.4190.14.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Anil Veerabhadrappa <anilgv@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>


On Sun, 2009-06-28 at 10:25 -0700, James Bottomley wrote:
> On Sun, 2009-06-28 at 08:46 -0700, Michael Chan wrote:
> > James Bottomley wrote:
> > 
> > > On Tue, 2009-06-23 at 18:11 -0700, Anil Veerabhadrappa wrote:
> > > > >From a8267738e9ca5c73ad6c0d89f17cf864bfc908c8 Mon Sep 17
> > > 00:00:00 2001
> > > > From: Anil Veerabhadrappa <anilgv@broadcom.com>
> > > > Date: Tue, 23 Jun 2009 13:56:29 -0700
> > > > Subject: [PATCH]     bnx2i - remove global variable
> > > bnx2i_reg_devices
> > > >
> > > >     * Removed bnx2i_reg_devices as this counter is not really
> > > >       used in a meaningful way
> > > >     Cc: Mike Christie <michaelc@cs.wisc.edu>
> > > >
> > > > Signed-off-by: Michael Chan <mchan@broadcom.com>
> > > > Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
> > >
> > > Tell me what these signoffs mean:  The first signoff by Michael Chan
> > > implies it's his patch, but it has your authorship information.
> > >
> > 
> > Sorry, Anil should have put his signoff first.  Do we need to re-spin
> > the pacthes?
> 
> So did you actually contribute to these?  In which case a note saying
> something like 
> 
> [mchan: did X to the driver]

Here's one example of what I did:

[mchan: bnx2i_init_one() - don't add hba to adater_list if
->register_device fails ]

In general, all our patchsets go through some internal review and
testing by others besides the author.  We use multiple signoffs to
include everyone who has made some contributions to the patchset.  We'll
try to be more specific about who did what in the future. 

Thanks.

> 
> is useful ... otherwise if you're just confirming as maintainer it
> should be acked-by (unless you send me the patches yourself).
> 



