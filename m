From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH v5 2/2] block,scsi: convert and handle ERR_PTR from
 blk_get_request
Date: Mon, 27 May 2013 16:42:17 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1305271642050.3914@pobox.suse.cz>
References: <alpine.DEB.2.02.1303171328250.1736@jlaw-desktop.mno.stratus.com> <20130524141531.737073a8@jlaw-desktop.mno.stratus.com> <20130524141728.30abc1ce@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33557 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833Ab3E0OmS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 May 2013 10:42:18 -0400
In-Reply-To: <20130524141728.30abc1ce@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Bart Van Assche <bvanassche@acm.org>

On Fri, 24 May 2013, Joe Lawrence wrote:

> From 5b26d593807b30f60ed41f6fd5a16a56c3c9a43c Mon Sep 17 00:00:00 2001
> From: Joe Lawrence <joe.lawrence@stratus.com>
> Date: Fri, 24 May 2013 13:05:09 -0400
> Subject: [PATCH v5 2/2] block,scsi: convert and handle ERR_PTR from blk_get_request
> 
> The blk_get_request function may fail in low-memory conditions or during
> device removal (even if __GFP_WAIT is set). To distinguish between these
> errors, modify the blk_get_request call stack to return the appropriate
> ERR_PTR. Verify that all callers check the return status and consider
> IS_ERR instead of a simple NULL pointer check.
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: linux-scsi@vger.kernel.org
> ---
>  block/blk-core.c                            | 34 ++++++++++++++---------------
>  block/bsg.c                                 |  8 +++----
>  block/scsi_ioctl.c                          | 12 +++++-----
>  drivers/block/paride/pd.c                   |  4 ++--
>  drivers/block/pktcdvd.c                     |  4 ++--

Acked-by: Jiri Kosina <jkosina@suse.cz>

for the pktdvd.c change.

Thanks Joe.

-- 
Jiri Kosina
SUSE Labs
