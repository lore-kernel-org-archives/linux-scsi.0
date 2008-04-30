From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Recurring qla2xxx crashes (maybe APIC related)
Date: Wed, 30 Apr 2008 10:18:10 -0700
Message-ID: <20080430171810.GC80852@n6016av4ptjbf1.qlogic.org>
References: <4811ACAC.7060808@linpro.no> <20080425155018.GG8849@plap4> <48120F8B.7060005@linpro.no> <20080425171821.GK8849@plap4> <4815709C.3060502@linpro.no> <20080429211655.GA72811@plap4.qlogic.org> <4817970A.4030807@linpro.no> <20080429222947.GE72811@plap4.qlogic.org> <48182E8F.6000009@linpro.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:37801 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093AbYD3RSM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Apr 2008 13:18:12 -0400
Content-Disposition: inline
In-Reply-To: <48182E8F.6000009@linpro.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tore Anderson <tore@linpro.no>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 30 Apr 2008, Tore Anderson wrote:

> * Andrew Vasquez
> 
> > We did notice that the RISC firmware being loaded is quite dated (15 
> > months):
> 
> I did ensure that we were running the latest firmware when trying to
> track down the problem.  From what I can tell 4.00.27 was the latest
> available on your FTP up until the 23rd of April.  I simply didn't check
> to see if any updates were published in the last week.

Ok, I see where the confusion lies...  I've always updated
ql2400_fw.bin to the latest FW version, and simply renamed older
versions to ql2400_fw.bin.X.YY.ZZ.  To avoid any future uncertainty,
I've changed the layout a bit and now archive older firmware versions
in an 'old' directory...

> > At a minimum, our FW folks suggested 4.01.00 should be used to
> > address any known residual MSI issues at the RISC-side.  You can
> > download the latest 24xx firmware (4.04.00) here:
> 
> The sysadmins have requested that I leave the box alone for a few days
> more so we can tell our customer that we're 100% confident we have a
> viable workaround for the stability problems.  I'll reboot with MSI
> enabled and FW 4.04.00 on Friday, and will let you know how it's going
> on Monday.
> 
> I hope you're okay with waiting until then.

That's fine.

Thanks again,
Andrew Vasquez
