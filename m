From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 1/2] cciss: fix for 2TB support
Date: Fri, 23 Feb 2007 22:35:22 -0800
Message-ID: <20070223223522.f87dfc4b.akpm@linux-foundation.org>
References: <20070221211039.GA2672@beardog.cca.cpqcorp.net>
	<20070221191427.9b7cf4b0.akpm@linux-foundation.org>
	<20070222165123.GC2672@beardog.cca.cpqcorp.net>
	<20070222132434.d84d3248.akpm@linux-foundation.org>
	<1172180484.3378.34.camel@mulgrave.il.steeleye.com>
	<20070222220225.GC14162@beardog.cca.cpqcorp.net>
	<1172182001.3378.38.camel@mulgrave.il.steeleye.com>
	<20070223205229.GB10570@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51661 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933393AbXBXGjn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Feb 2007 01:39:43 -0500
In-Reply-To: <20070223205229.GB10570@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: James.Bottomley@SteelEye.com, mike.miller@hp.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com

> On Fri, 23 Feb 2007 14:52:29 -0600 "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> On Thu, Feb 22, 2007 at 04:06:41PM -0600, James Bottomley wrote:
> > On Thu, 2007-02-22 at 16:02 -0600, Mike Miller (OS Dev) wrote:
> > > Will this patch for my patch work for now?
> > 
> > Yes, I think that should be fine ... it's only a theoretical worry; at
> > the moment sector_t is unsigned ... but just in case.
> > 
> > James
> > 
> > 
> Andrew,
> Are you waiting for a new patch from me? Or is my patch's patch sufficient?
> 

It looked OK.  But I'm travelling at present, will get back into things
late next week.

