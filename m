From: Chris Adams <cmadams@hiwaay.net>
Subject: Re: Why are MegaRAID drivers mutually exclusive?
Date: Thu, 11 Nov 2004 08:07:45 -0600
Message-ID: <20041111140745.GA1508368@hiwaay.net>
References: <0E3FA95632D6D047BA649F95DAB60E570562C174@exa-atlanta> <20041110220854.GB28524@lists.us.dell.com> <1100160080.2646.10.camel@laptop.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bee.hiwaay.net ([216.180.54.11]:44564 "EHLO bee.hiwaay.net")
	by vger.kernel.org with ESMTP id S262237AbUKKOIB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2004 09:08:01 -0500
Content-Disposition: inline
In-Reply-To: <1100160080.2646.10.camel@laptop.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, "Mukker, Atul" <Atulm@lsil.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Once upon a time, Arjan van de Ven <arjanv@redhat.com> said:
> On Wed, 2004-11-10 at 16:08 -0600, Matt Domsch wrote:
> > How about you remove all the PCI IDs from the 2.00.3 driver that the
> > 2.20 driver handles, so that they're mutually exclusive again?
> 
> Are they mutually exclusive in other places too? (eg in the /proc stuff
> it creates... well I guess the new driver only does (or should do) sysfs
> of course)

It looks like the only place they overlap is in the device node.

I don't see this as being all that different from when there were
multiple sym53c8xx SCSI or tulip network drivers in the kernel.
-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
