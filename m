From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 4/6] SCSI sd driver calls revalidate_disk wrapper.
Date: Wed, 03 Sep 2008 14:17:54 -0400
Message-ID: <x49abep9jql.fsf@segfault.boston.devel.redhat.com>
References: <20080829231254.25065.66052.stgit@bluto.andrew>
	<20080829231315.25065.5250.stgit@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55083 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbYICShV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2008 14:37:21 -0400
In-Reply-To: <20080829231315.25065.5250.stgit@bluto.andrew> (Andrew
	Patterson's message of "Fri, 29 Aug 2008 17:13:15 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com

Andrew Patterson <andrew.patterson@hp.com> writes:

> SCSI sd driver calls revalidate_disk wrapper.
>
> Modify the SCSI disk driver to call the revalidate_disk()
> wrapper. This allows us to do some housekeeping such as accounting for
> a disk being resized online. The wrapper will call
> sd_revalidate_disk() at the appropriate time.
>
> Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
