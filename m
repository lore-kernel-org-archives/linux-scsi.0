From: Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 2/2] libsas fails to compile on s390
Date: Fri, 10 Nov 2006 01:22:29 -0800
Message-ID: <20061110012229.6e61ad25.akpm@osdl.org>
References: <200611090357.kA93vA1u004099@shell0.pdx.osdl.net>
	<20061109003407.f2c5ea5b.akpm@osdl.org>
	<20061110075050.GD7129@osiris.boeblingen.de.ibm.com>
	<20061110003908.ac98ee66.akpm@osdl.org>
	<20061110090044.GE7129@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:40421 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1946148AbWKJJWj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Nov 2006 04:22:39 -0500
In-Reply-To: <20061110090044.GE7129@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, schwidefsky@de.ibm.com

On Fri, 10 Nov 2006 10:00:44 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Fri, Nov 10, 2006 at 12:39:08AM -0800, Andrew Morton wrote:
> > > But maybe we should simply merge this one
> > > instead?
> > > 
> > > http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.19-rc5/2.6.19-rc5-mm1/broken-out/git-sas-kconfig-fix.patch
> > 
> > The original failure which we're tryimg to fix here occurred with that
> > patch applied.
> > 
> > Oh well.
> 
> How that? s390 doesn't have CONFIG_ATA... This compile error only happens on
> 2.6.19-rc5 but not your -mm tree. That's why I thought the above mentioned
> patch should fix this.
> Maybe SCSI_SAS_LIBSAS should depend on SCSI && ATA && PCI?

umm, with git-sas-kconfig-fix.patch applied, `make allmodconfig' does:

box:/usr/src/25> grep SAS .config
CONFIG_SCSI_SAS_ATTRS=m

and... it compiles.  I must be dreaming.
