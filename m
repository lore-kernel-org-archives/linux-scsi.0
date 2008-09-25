From: "Jing Huang" <huangj@Brocade.COM>
Subject: RE: [PATCH 1/6] bfa: Brocade BFA FC SCSI Driver submission
Date: Wed, 24 Sep 2008 22:33:26 -0700
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E01F27D49@HQ-EXCH-5.corp.brocade.com>
References: <4C94DE2070B172459E4F1EE14BD2364E01F27D19@HQ-EXCH-5.corp.brocade.com> <20080925044923.GA4310@kroah.com> <1222319644.3602.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx40.brocade.com ([144.49.195.4]:58018 "EHLO mx40.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbYIYFeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Sep 2008 01:34:08 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1222319644.3602.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>, "Srikanth Rayas (CW)" <srayas@Brocade.COM>

Thanks James and Greg for the quick check on the patches.

I check the original patch, it is correct. I need to check the outlook
setting to see how to prevent this issue.

This is my first time sending a patch, is there any trick to prevent
line-wrap? I did send it using plain text and I tried to send to myself
before sending to lkml, and I did't see this problem.

Sorry about the trouble.

Jing

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Wednesday, September 24, 2008 10:14 PM
To: Greg KH
Cc: Jing Huang; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; Ramkumar Vadivelu; Vinodh Ravindran;
Srikanth Rayas (CW)
Subject: Re: [PATCH 1/6] bfa: Brocade BFA FC SCSI Driver submission

On Wed, 2008-09-24 at 21:49 -0700, Greg KH wrote:
> On Wed, Sep 24, 2008 at 08:56:14PM -0700, Jing Huang wrote:
> > --- orig/drivers/scsi/bfa/bfad_attr.c	1969-12-31
16:00:00.000000000
> > -0800
> > +++ patch/drivers/scsi/bfa/bfad_attr.c	2008-09-24
12:08:23.000000000
> > -0700
> > @@ -0,0 +1,660 @@
> > +/*
> > + * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
> > + * All rights reserved
> > + * www.brocade.com
> > + *
> > + * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> > + *
> > + * This program is free software; you can redistribute it and/or
modify
> > it
> 
> Your patch is line-wrapped and can't be applied :(

Actually, it's more than just linewrapping.  The patch to the Makefile
looks to be actively mangled:

+++ patch/drivers/scsi/bfa/Makefile     2008-09-24 12:08:24.000000000
-0700
@@ -0,0 +1,25 @@
+#
+# Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+# All rights reserved
+# www.brocade.com
+#
+# Linux driver for Brocade Fibre Channel Host Bus Adapter.
+#
+# This program is free software; you can redistribute it and/or modify 
+it # under the terms of the GNU General Public License (GPL) Version 2 
+as # published by the Free Software Foundation # # This program is 
+distributed in the hope that it will be useful, but # WITHOUT ANY 
+WARRANTY; without even the implied warranty of # MERCHANTABILITY or 
+FITNESS FOR A PARTICULAR PURPOSE.  See the GNU # General Public License

The # beginning the line got wrapped here before the patch was made.

James


