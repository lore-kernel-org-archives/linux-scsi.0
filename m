From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: 2.6.0 stability and the BK scsi trees
Date: Sat, 18 Oct 2003 08:24:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031018082450.A6510@beaverton.ibm.com>
References: <1066265974.16761.426.camel@fuzzy> <3F8E8786.2020502@torque.net> <20031016132804.GA18370@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:55024 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S261664AbTJRP0A
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Oct 2003 11:26:00 -0400
Content-Disposition: inline
In-Reply-To: <20031016132804.GA18370@parcelfarce.linux.theplanet.co.uk>; from willy@debian.org on Thu, Oct 16, 2003 at 02:28:04PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com

On Thu, Oct 16, 2003 at 02:28:04PM +0100, Matthew Wilcox wrote:
> On Thu, Oct 16, 2003 at 09:56:54PM +1000, Douglas Gilbert wrote:
> > What was the point of putting 32 dev_t's into the
> > kernel? Many people who were advocating it used
> > the increased number of scsi disks (> 256) and
> > partitions (from 15 to 63 [to match the ide subsystem])
> > as a major reason.
> > 
> > The sd driver is still littered with hacks to distribute
> > its 256 (max) disks over 8 majors. Shouldn't this be
> > fixed?
> 
> Well, let's see some fixes and then decide whether it's worth merging
> before 2.6.0 or after 2.6.0.  We can be sure that vendors will integrate
> this patch even if it's not in mainline kernel.org ... and i'd rather
> see one variant of the patch which everybody uses than a different one
> in RH, SuSE and Linux 2.7.

If you have not seen it, Badari's sd patch is in the mm tree:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.0-test7/2.6.0-test7-mm1/broken-out/support-zillions-of-scsi-disks.patch

-- Patrick Mansfield
