From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PATCH 2.6.11-rc4 rename IOMAPPED config option
Date: Sun, 20 Feb 2005 21:09:36 -0500
Message-ID: <20050221020936.GA22713@havoc.gtf.org>
References: <20050221010758.GC30800@colo.lackof.org> <4219355E.1000807@pobox.com> <20050221020221.GA28741@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from atlmail.prod.rxgsys.com ([64.74.124.160]:28837 "EHLO
	bastet.signetmail.com") by vger.kernel.org with ESMTP
	id S261488AbVBUCJv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 21:09:51 -0500
Content-Disposition: inline
In-Reply-To: <20050221020221.GA28741@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>, willy@parisc-linux.org, linux-scsi@vger.kernel.org

On Mon, Feb 21, 2005 at 02:02:21AM +0000, Matthew Wilcox wrote:
> On Sun, Feb 20, 2005 at 08:11:58PM -0500, Jeff Garzik wrote:
> > Patch doesn't apply with -p1.
> 
> Doesn't matter; I can cope with both.

Irrelevant.  It matters to automated patch snarfers, lkml.org users, etc.


> > >--- drivers/scsi/sym53c8xx_2/sym_glue.c	20 Feb 2005 23:49:27 -0000 
> > >1.84
> > 
> > This file does not include <linux/config.h>.
> 
> Doesn't need to -- sym_glue.h does.
> 
> > >--- drivers/scsi/sym53c8xx_2/sym_hipd.c	16 Feb 2005 20:54:02 -0000 
> > >1.48
> > 
> > ditto
> 
> ditto.

Incorrect.  <linux/config.h> is not a standard include; you need to
include linux/config.h in each file that uses a CONFIG_xxx define.

	Jeff



