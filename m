From: Christoph Hellwig <hch@infradead.org>
Subject: Re: next-20140925 build: 1 failures 106 warnings (next-20140925)
Date: Thu, 25 Sep 2014 08:46:52 -0700
Message-ID: <20140925154652.GA29864@infradead.org>
References: <E1XX7vn-0003PS-Vu@cassiel.sirena.org.uk>
 <20140925153120.GX27755@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaIYPq5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Sep 2014 11:46:57 -0400
Content-Disposition: inline
In-Reply-To: <20140925153120.GX27755@sirena.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, kernel-build-reports@lists.linaro.org, linaro-kernel@lists.linaro.org, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

On Thu, Sep 25, 2014 at 04:31:20PM +0100, Mark Brown wrote:
> On Thu, Sep 25, 2014 at 01:13:56PM +0100, Build bot for Mark Brown wrote:
> 
> > 	arm-allmodconfig
> > ERROR: "__aeabi_uldivmod" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!
> 
> Today's ARM allmodconfig fails to build due to a call to a GCC intrinsic
> being emitted from the mpt2sas module - I've not made any effort to
> investigate this myself yet, unfortunately there's been a build error in
> this configuration for arch/arm for the past week or so which means that
> the error may not have been introduced today.

http://git.infradead.org/users/hch/scsi-queue.git/commitdiff/f78f694c34ae6fdc29f5e80abb2dbb894f961772

I just need James to pull the latests scsi-queue tree changes..

