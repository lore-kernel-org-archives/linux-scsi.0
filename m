From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: linux-next: Tree for December 27 (drivers/target)
Date: Tue, 28 Dec 2010 09:08:35 -0600
Message-ID: <1293548915.2371.0.camel@fuzzy>
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
	 <20101227115755.ffcdfc4f.randy.dunlap@oracle.com>
	 <1293490179.4649.208.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49668 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab0L1PKO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Dec 2010 10:10:14 -0500
In-Reply-To: <1293490179.4649.208.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Mon, 2010-12-27 at 14:49 -0800, Nicholas A. Bellinger wrote:
> On Mon, 2010-12-27 at 11:57 -0800, Randy Dunlap wrote:
> > On Mon, 27 Dec 2010 17:04:51 +1100 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > [The mirroring on kernel.org is running slowly]
> > > 
> > > Changes since 20101221:
> > > 
> > > Linus' tree lost its build failure.
> > 
> > 
> > Hi Nick,
> > 
> > Please test building target code when CONFIG_BLOCK is not enabled.
> > 
> > When CONFIG_BLOCK is not enabled, drivers/target/ gets a boat load of build errors.
> > 
> > Should TCM_IBLOCK depend on BLOCK?  That fixes lots of the build errors,
> > but not all of them.
> > 
> > 
> > The header file include/target/target_core_base.h uses struct queue_limits,
> > so it should #include <linux/blkdev.h>.
> > 
> > 
> 
> Added the missing include here:
> 
> target: Add linux/blkdev.h include in target_core_base.h
> http://git.kernel.org/?p=linux/kernel/git/nab/linux-next.git;a=commitdiff;h=e8bd07d3a525e71b424d308fc5084b89a6456bb2
> 
> Thanks Randy!

Could you just do mod patches inline to the list, please?  It's much
less convenient trying to pull them out of a web page.

Thanks,

James


