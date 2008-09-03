From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/6] Wrapper for lower-level revalidate_disk routines.
Date: Wed, 03 Sep 2008 14:16:55 -0400
Message-ID: <x49myip9js8.fsf@segfault.boston.devel.redhat.com>
References: <20080829231254.25065.66052.stgit@bluto.andrew>
	<20080829231259.25065.79887.stgit@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53021 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbYICSVa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2008 14:21:30 -0400
In-Reply-To: <20080829231259.25065.79887.stgit@bluto.andrew> (Andrew
	Patterson's message of "Fri, 29 Aug 2008 17:13:00 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com

Andrew Patterson <andrew.patterson@hp.com> writes:

> Wrapper for lower-level revalidate_disk routines.
>
> This is a wrapper for the lower-level revalidate_disk call-backs such
> as sd_revalidate_disk(). It allows us to perform pre and post
> operations when calling them.
>
> We will use this wrapper in a later patch to adjust block device sizes
> after an online resize (a _post_ operation).
>
> Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
