From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: blk_queue_hardsect_size 520-byte sector
Date: Fri, 6 Jun 2008 09:54:33 +0200
Message-ID: <20080606075432.GH5757@kernel.dk>
References: <339116.28290.qm@web32404.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:4953 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758660AbYFFHyg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2008 03:54:36 -0400
Content-Disposition: inline
In-Reply-To: <339116.28290.qm@web32404.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil kumar <anils_r@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Jun 05 2008, Anil kumar wrote:
> Hi,
> 
> Can I call blk_queue_hardsect_size in a driver and set it to 520-byte
> as hardware sector size.  How does the kernel and block layers take
> the request, will it be in multiples of 520-bytes aligned or 512 bytes
> aligned?

No, Linux only supports power-of-2 hardware block sizes I'm afraid.

-- 
Jens Axboe

