From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Recurring qla2xxx crashes (maybe APIC related)
Date: Tue, 6 May 2008 07:02:05 -0700
Message-ID: <20080506140205.GB46493@plap4.qlogic.org>
References: <48120F8B.7060005@linpro.no> <20080425171821.GK8849@plap4> <4815709C.3060502@linpro.no> <20080429211655.GA72811@plap4.qlogic.org> <4817970A.4030807@linpro.no> <20080429222947.GE72811@plap4.qlogic.org> <48182E8F.6000009@linpro.no> <20080430171810.GC80852@n6016av4ptjbf1.qlogic.org> <481EBBE4.5000005@linpro.no> <481F6748.80306@linpro.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:10480 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbYEFOCF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2008 10:02:05 -0400
Content-Disposition: inline
In-Reply-To: <481F6748.80306@linpro.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tore Anderson <tore@linpro.no>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 05 May 2008, Tore Anderson wrote:

> * Tore Anderson
> 
> > Anyway.  The problematic box has now been running with FW 4.04.00 and
> > MSI active for 60 hours now, so it looks like the old FW was the
> > cause of the instability.  I'll leave it running and will let you
> > know if any problems occur, though.
> 
> It lasted 72 hours and 25 minutes with the new firmware.  More than what
> the average was with the old one, but still not very impressive.
> 
> I'm attaching the kernel log from the entire period.

I managed to get an HS21 configuration (with 2422 mezz card) running
within the lab (with latest linux-2.6.git tree) against some IBM
storage.  It's been running now for 12+ hours with MSI enabled.  I'll
let it run for several days (if no failures), then restart with
2.6.22.19 for a weekend run...

> Now I'm running with the new FW and pci=nomsi.  I expect this to work
> just as fine as with the old FW - I will let you know if not.

Hrrm...  still haven't discounted some potential hardware problems...

Thanks for the update,
Andrew Vasquez
