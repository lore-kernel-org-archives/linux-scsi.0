From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Wed, 11 Dec 2002 08:18:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1266570000.1039619906@aslan.scsiguy.com>
References: <hch@infradead.org>
 <200212101602.gBAG2Hi02930@localhost.localdomain>
 <20021211135855.A19325@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021211135855.A19325@infradead.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

> Okay, here's a lightly tested patch to get it in shape and
> compile/useable..

Why is this based on Alpha1 and not Alpha2.  Several of the things
you fixed are already fixed in Alpha2.  I just redownloaded what
I put up on my site and, as an example, verified that both the
pdev->driver_data and slave_alloc/configure/destroy stuff is already
in there (I wouldn't have been able to build on 2.5.X if it weren't).

Also, changes that remove compatibility ifdefs will be ignored.  This
driver has to build all the way back to 2.4.7 (RedHat 7.2 support).
Removing ifdefs just makes it harder for me to merge in changes from
external trees.  Yes, the ifdefs are ugly, but so is the Linux SCSI layer
and the unmanaged way that interfaces have been changed without any
consideration to backwards compatibility (eg. the HIGHIO stuff could have
been done with 0 impact to drivers, but wasn't for some strange reason).

>   - fix kbuild integration

Can you explain what failed before?  I don't mind using aic7xxx-y
or aic79xx-y instead of *-obj, but I would like to understand what
bug this fixes.

Thanks,
Justin


