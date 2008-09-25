From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/6] bfa: Brocade BFA FC SCSI Driver submission
Date: Wed, 24 Sep 2008 22:14:04 -0700
Message-ID: <1222319644.3602.1.camel@localhost.localdomain>
References: <4C94DE2070B172459E4F1EE14BD2364E01F27D19@HQ-EXCH-5.corp.brocade.com>
	 <20080925044923.GA4310@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58395 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616AbYIYFOq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2008 01:14:46 -0400
In-Reply-To: <20080925044923.GA4310@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Jing Huang <huangj@Brocade.COM>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>, "Srikanth Rayas (CW)" <srayas@Brocade.COM>

On Wed, 2008-09-24 at 21:49 -0700, Greg KH wrote:
> On Wed, Sep 24, 2008 at 08:56:14PM -0700, Jing Huang wrote:
> > --- orig/drivers/scsi/bfa/bfad_attr.c	1969-12-31 16:00:00.000000000
> > -0800
> > +++ patch/drivers/scsi/bfa/bfad_attr.c	2008-09-24 12:08:23.000000000
> > -0700
> > @@ -0,0 +1,660 @@
> > +/*
> > + * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
> > + * All rights reserved
> > + * www.brocade.com
> > + *
> > + * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
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


