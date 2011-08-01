From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 9/9] isci: add version number
Date: Mon, 01 Aug 2011 12:54:46 -0500
Message-ID: <1312221286.8212.29.camel@mulgrave>
References: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
	 <20110730001721.28430.28086.stgit@localhost6.localdomain6>
	 <20110730185507.7b68c0a7@stein>
	 <CAA9_cmfnSVdohf5bkfXjZvsa+O2vjvVdy2RA=f2EfVYeXdkX+Q@mail.gmail.com>
	 <20110801193806.57dc9b58@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59664 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753986Ab1HARyu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2011 13:54:50 -0400
In-Reply-To: <20110801193806.57dc9b58@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org

On Mon, 2011-08-01 at 19:38 +0200, Stefan Richter wrote:
> On Aug 01 Dan Williams wrote:
> > On Sat, Jul 30, 2011 at 9:55 AM, Stefan Richter
> > <stefanr@s5r6.in-berlin.de> wrote:
> > > On Jul 29 Dan Williams wrote:
> > >> @@ -540,7 +548,8 @@ static __init int isci_init(void)
> > >>  {
> > >>       int err;
> > >>
> > >> -     pr_info("%s: Intel(R) C600 SAS Controller Driver\n", DRV_NAME);
> > >> +     pr_info("%s: Intel(R) C600 SAS Controller Driver - version %s\n",
> > >> +             DRV_NAME, DRV_VERSION);
> > >
> > > Why?  There is already a version number.  Like 2.6.39, 3.0, 3.1.
> > 
> > This is for tracking driver versions across distributions and driver
> > update packages as they sync with upstream on different cadences.
> 
> If they "synced with upstream", they had just the kernel version number.
> You mean they "backport new drivers from current upstream into their branch
> with an old core".

This isn't good enough for distros, who often pretend to be on one
kernel version yet have the driver backported from another.

> The mainline doesn't generally carry stubs and macros that are only there
> for backporting.  Well, I guess SCSI drivers are different in that regard.

This is hardly a stub for a backport.  It's a printk printing the
version.  At least 25% of drivers seem to do this (not that I entirely
approve ... it does tend to clutter the boot sequence a bit)

The whole reason for MODULE_VERSION() is to mark this correctly.

James


