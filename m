From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: scsi, was Re: -mm merge plans for 2.6.23
Date: Wed, 11 Jul 2007 10:22:35 -0700
Message-ID: <20070711102235.5a7ccaaa.akpm@linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070711113718.GB18665@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48068 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbXGKRX0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2007 13:23:26 -0400
In-Reply-To: <20070711113718.GB18665@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 11 Jul 2007 13:37:18 +0200 Christoph Hellwig <hch@lst.de> wrote:

> > restore-acpi-change-for-scsi.patch
> > git-scsi-misc-vs-greg-sysfs-stuff.patch
> > aacraid-rename-check_reset.patch
> > scsi-dont-build-scsi_dma_mapunmap-for-has_dma.patch
> > drivers-scsi-small-cleanups.patch
> > sym53c8xx_2-claims-cpqarray-device.patch
> > drivers-scsi-wd33c93c-cleanups.patch
> > make-seagate_st0x_detect-static.patch
> > pci-error-recovery-symbios-scsi-base-support.patch
> > pci-error-recovery-symbios-scsi-first-failure.patch
> > drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
> > drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc.patch
> > drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc.patch
> > use-menuconfig-objects-ii-scsi.patch
> > remove-dead-references-to-module_parm-macro.patch
> > ppa-coding-police-and-printk-levels.patch
> > remove-the-dead-cyberstormiii_scsi-option.patch
> > config_scsi_fd_8xx-no-longer-exists.patch
> > use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver.patch
> > 
> >  Sent to James.
> 
> Care to drop the patches James NACKed every single time?

I'm not aware of any which fit that description.

There may be a couple in there which fix real bugs in an unapproved way. 
But I keep such patches as a matter of policy, so people keep on getting
pestered about their bugs.

