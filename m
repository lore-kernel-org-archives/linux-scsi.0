From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH/RFC v2] allow userspace to modify scsi command filter
 on per device basis
Date: Mon, 16 Jun 2008 11:55:24 +0900
Message-ID: <20080616115952W.fujita.tomonori@lab.ntt.co.jp>
References: <6cf6b73e0806131322n7642d2d1ne90f70c2b3728f8@mail.gmail.com>
	<6cf6b73e0806131323w5b921c05jd1166ab88471bfd1@mail.gmail.com>
	<6cf6b73e0806132351r20fe8f91o479cd102978fa483@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:47061 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYFPCz4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Jun 2008 22:55:56 -0400
In-Reply-To: <6cf6b73e0806132351r20fe8f91o479cd102978fa483@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adel.gadllah@gmail.com
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, pjones@redhat.com, jens.axboe@oracle.com

On Sat, 14 Jun 2008 08:51:16 +0200
"Adel Gadllah" <adel.gadllah@gmail.com> wrote:

> Attached a new version of the patch.
> Moved the sysfs entry up one level (to not be in the "holders"
> directory) and renamed it t cmd_filter (reflects its purpose better
> than "filter").
> 
> -----------------------------
> 
> From: Peter Jones <pjones@redhat.com>
> 
> This patch exports the per-gendisk command filter to user space through
> sysfs, so it can be changed by the system administrator.
> 
> Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
> Signed-off-by: Peter Jones <pjones@redhat.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

I think that the scsi command filter infrastructure should work with
all the interfaces, bsg, SG_IO, and sg. This doesn't work with sg,
right?
