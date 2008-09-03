From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 3/6] Check for device resize when rescanning partitions
Date: Wed, 03 Sep 2008 14:17:34 -0400
Message-ID: <x49ej419jr5.fsf@segfault.boston.devel.redhat.com>
References: <20080829231254.25065.66052.stgit@bluto.andrew>
	<20080829231310.25065.40311.stgit@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55013 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbYICSeP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2008 14:34:15 -0400
In-Reply-To: <20080829231310.25065.40311.stgit@bluto.andrew> (Andrew
	Patterson's message of "Fri, 29 Aug 2008 17:13:10 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com

Andrew Patterson <andrew.patterson@hp.com> writes:

> Check for device resize when rescanning partitions
>
> Check for device resize in the rescan_partitions() routine. If the device
> has been resized, the bdev size is set to match. The rescan_partitions()
> routine is called when opening the device and when calling the
> BLKRRPART ioctl.
>
> Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
