From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [PATCH 1/1] cciss: resubmit export uid, model, vendor, rev to sysfs
Date: Wed, 8 Apr 2009 09:53:38 -0500
Message-ID: <20090408145338.GA3998@beardog.cca.cpqcorp.net>
References: <20090407180411.GA4324@beardog.cca.cpqcorp.net> <20090408061901.GN5178@kernel.dk> <20090408081337.GX5178@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:5164 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763019AbZDHOxi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2009 10:53:38 -0400
Content-Disposition: inline
In-Reply-To: <20090408081337.GX5178@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, LKML-SCSI <linux-scsi@vger.kernel.org>, andrew.patterson@hp.com, mike.miller@hp.com, kay.sievers@vrfy.org

On Wed, Apr 08, 2009 at 10:13:37AM +0200, Jens Axboe wrote:
> On Wed, Apr 08 2009, Jens Axboe wrote:
> > On Tue, Apr 07 2009, Mike Miller (OS Dev) wrote:
> > > Patch 1 of 1 resubmit
> > > 
> > > cciss: add cciss driver sysfs entries
> > > 
> > > This patch adds sysfs entries to the cciss driver needed for the
> > > dm/multipath tools. A file for vendor, model, rev, and unique_id are
> > > added for each logical drive under directory
> > > /sys/bus/pci/devices/<dev>/ccissX/cXdY. Where X = the controller (or
> > > host) number and Y is the logical drive number. A link from
> > > /sys/bus/pci/devices/<dev>/ccissX/cXdY/block:cciss!cXdY to
> > > /sys/block/cciss!cXdY/device is also created.
> > > 
> > > From: Andrew Patterson <andrew.patterson@hp.com>
> > 
> > You want to put that at the top of the email, so you have
> > {from,description,signed-offs} in that order.
> > 
> > The patch looks fine to me, but my sysfs foo is very weak though. CC'ing
> > Kay, perhaps he can help take a quick look at this.
> 
> It doesn't apply to 2.6.30-rc1:
> 
> patching file Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
> patching file drivers/block/cciss.c
> Hunk #1 succeeded at 437 (offset 3 lines).
> Hunk #2 succeeded at 1518 (offset 20 lines).
> Hunk #3 succeeded at 1597 (offset 20 lines).
> Hunk #4 succeeded at 1688 (offset 20 lines).
> Hunk #5 succeeded at 1739 (offset 20 lines).
> Hunk #6 succeeded at 1816 (offset 20 lines).
> Hunk #7 succeeded at 1825 (offset 20 lines).
> Hunk #8 succeeded at 1950 (offset 20 lines).
> Hunk #9 succeeded at 3956 with fuzz 2 (offset 93 lines).
> Hunk #10 succeeded at 4108 (offset 98 lines).
> Hunk #11 succeeded at 4220 (offset 101 lines).
> patching file drivers/block/cciss.h
> Hunk #3 FAILED at 131.
> 1 out of 3 hunks FAILED -- saving rejects to file
> drivers/block/cciss.h.rej
> 
My apologies, I built this against 2.6.29 not thinking that my other
changes had been merged.

But it looks like Kay has issues with the patch. Andrew P.?

-- mikem
