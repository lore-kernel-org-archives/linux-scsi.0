From: mikem <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [patch 1/2] cciss: cleans up warnings in the 32/64 bit conversions
Date: Tue, 26 Oct 2004 14:45:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041026194551.GA21003@beardog.cca.cpqcorp.net>
References: <20041021211718.GA10462@beardog.cca.cpqcorp.net> <1098633262.10824.35.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel11.hp.com ([156.153.255.246]:41910 "EHLO palrel11.hp.com")
	by vger.kernel.org with ESMTP id S261495AbUJZTqP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 15:46:15 -0400
Content-Disposition: inline
In-Reply-To: <1098633262.10824.35.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: marcelo.tosatti@cyclades.com, Jens Axboe <axboe@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, Oct 24, 2004 at 11:54:15AM -0400, James Bottomley wrote:
> On Thu, 2004-10-21 at 17:17, mike.miller@hp.com wrote:
> > Patch 1 of 2 for 20041021.
> > This patch cleans up some warnings in the 32-bit to 64-bit conversions.
> > Please consider this for inclusion. Built against 2.4.28-pre4.
> > Please apply in order.
> 
> There's something wrong with this patch (it might be a missing prior
> patch) that's causing it to reject comprehensively.
> 
> > -typedef long (*handler_type) (unsigned int, unsigned int, unsigned long,
> > +typedef int (*handler_type) (unsigned int, unsigned int, unsigned long,
> 
> Things like this.  handler_type has always been int not long in the
> source that's currently in the tree.
> 
> James
> 

Which tree are you applying to? This was made from 2.4.28-pre4.

mikem

> 
