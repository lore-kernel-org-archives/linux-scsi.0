From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/1] cciss: resubmit export uid, model, vendor, rev to
	sysfs
Date: Wed, 8 Apr 2009 10:13:37 +0200
Message-ID: <20090408081337.GX5178@kernel.dk>
References: <20090407180411.GA4324@beardog.cca.cpqcorp.net> <20090408061901.GN5178@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762834AbZDHIOX@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090408061901.GN5178@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, LKML-SCSI <linux-scsi@vger.kernel.org>, andrew.patterson@hp.com, mike.miller@hp.com, kay.sievers@vrfy.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 08 2009, Jens Axboe wrote:
> On Tue, Apr 07 2009, Mike Miller (OS Dev) wrote:
> > Patch 1 of 1 resubmit
> > 
> > cciss: add cciss driver sysfs entries
> > 
> > This patch adds sysfs entries to the cciss driver needed for the
> > dm/multipath tools. A file for vendor, model, rev, and unique_id are
> > added for each logical drive under directory
> > /sys/bus/pci/devices/<dev>/ccissX/cXdY. Where X = the controller (or
> > host) number and Y is the logical drive number. A link from
> > /sys/bus/pci/devices/<dev>/ccissX/cXdY/block:cciss!cXdY to
> > /sys/block/cciss!cXdY/device is also created.
> > 
> > From: Andrew Patterson <andrew.patterson@hp.com>
> 
> You want to put that at the top of the email, so you have
> {from,description,signed-offs} in that order.
> 
> The patch looks fine to me, but my sysfs foo is very weak though. CC'ing
> Kay, perhaps he can help take a quick look at this.

It doesn't apply to 2.6.30-rc1:

patching file Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
patching file drivers/block/cciss.c
Hunk #1 succeeded at 437 (offset 3 lines).
Hunk #2 succeeded at 1518 (offset 20 lines).
Hunk #3 succeeded at 1597 (offset 20 lines).
Hunk #4 succeeded at 1688 (offset 20 lines).
Hunk #5 succeeded at 1739 (offset 20 lines).
Hunk #6 succeeded at 1816 (offset 20 lines).
Hunk #7 succeeded at 1825 (offset 20 lines).
Hunk #8 succeeded at 1950 (offset 20 lines).
Hunk #9 succeeded at 3956 with fuzz 2 (offset 93 lines).
Hunk #10 succeeded at 4108 (offset 98 lines).
Hunk #11 succeeded at 4220 (offset 101 lines).
patching file drivers/block/cciss.h
Hunk #3 FAILED at 131.
1 out of 3 hunks FAILED -- saving rejects to file
drivers/block/cciss.h.rej

-- 
Jens Axboe
