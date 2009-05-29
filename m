From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [PATCH v6] cciss: add cciss driver sysfs entries
Date: Fri, 29 May 2009 16:32:18 -0500
Message-ID: <20090529213218.GA20102@beardog.cca.cpqcorp.net>
References: <20090413164524.17977.99322.stgit@bluto.andrew> <20090413164530.17977.32550.stgit@bluto.andrew> <20090528202124.GB4846@beardog.cca.cpqcorp.net> <20090529124813.689b7667.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:16428 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbZE2Vbz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2009 17:31:55 -0400
Content-Disposition: inline
In-Reply-To: <20090529124813.689b7667.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jens.axboe@oracle.com, andrew.patterson@hp.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scameron@beardog.cca.cpqcorp.net

On Fri, May 29, 2009 at 12:48:13PM -0700, Andrew Morton wrote:
> On Thu, 28 May 2009 15:21:24 -0500
> "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> 
> > From: Andrew Patterson <andrew.patterson@hp.com>
> > 
> > This patch adds sysfs entries to the cciss driver needed for the
> > dm/multipath tools. A file for vendor, model, rev, and unique_id is
> > added for each logical drive under directory
> > /sys/bus/pci/devices/<dev>/ccissX/cXdY. Where X = the controller (or
> > host) number and Y is the logical drive number. A link from
> > /sys/bus/pci/devices/<dev>/ccissX/cXdY/block:cciss!cXdY to
> > /sys/block/cciss!cXdY/device is also created. A bus is created
> > in /sys/bus/cciss.  A link is created from the pci ccissX entry to
> > /sys/bus/cciss/devices/ccissX.
> > Please consider this for inclusion.
> > 
> > Signed-off-by: Mike Miller <mike.miller@hp.com>
> 
> Did Andrew's signed-off-by: get lost?

No, I converted it into the From: field. Another screw up, I guess.

mikem
