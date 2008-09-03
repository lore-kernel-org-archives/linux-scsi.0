From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/6] Adjust block device size after an online resize of a disk.
Date: Wed, 03 Sep 2008 14:17:19 -0400
Message-ID: <x49iqtd9jrk.fsf@segfault.boston.devel.redhat.com>
References: <20080829231254.25065.66052.stgit@bluto.andrew>
	<20080829231305.25065.3834.stgit@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59725 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbYICSXy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2008 14:23:54 -0400
In-Reply-To: <20080829231305.25065.3834.stgit@bluto.andrew> (Andrew
	Patterson's message of "Fri, 29 Aug 2008 17:13:05 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com

Andrew Patterson <andrew.patterson@hp.com> writes:

> Adjust block device size after an online resize of a disk.
>
> The revalidate_disk routine now checks if a disk has been resized by
> comparing the gendisk capacity to the bdev inode size.  If they are
> different (usually because the disk has been resized underneath the kernel)
> the bdev inode size is adjusted to match the capacity.
>
> Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
