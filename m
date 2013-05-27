From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH v5 1/2] block,scsi: verify return pointer from
 blk_get_request
Date: Mon, 27 May 2013 16:42:02 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1305271641380.3914@pobox.suse.cz>
References: <alpine.DEB.2.02.1303171328250.1736@jlaw-desktop.mno.stratus.com> <20130524141531.737073a8@jlaw-desktop.mno.stratus.com> <20130524141637.405c7f39@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932737Ab3E0OmF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 May 2013 10:42:05 -0400
In-Reply-To: <20130524141637.405c7f39@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Bart Van Assche <bvanassche@acm.org>

On Fri, 24 May 2013, Joe Lawrence wrote:

> From 22307be1bc6e404622b1f074094902e385a1bd30 Mon Sep 17 00:00:00 2001
> From: Joe Lawrence <joe.lawrence@stratus.com>
> Date: Fri, 24 May 2013 12:39:04 -0400
> Subject: [PATCH v5 1/2] block,scsi: verify return pointer from blk_get_request
> 
> The blk-core dead queue checks introduced in commit 70460571 added an
> error scenario to blk_get_request that returns NULL if the request queue
> has been shutdown. This changed the behavior for __GFP_WAIT callers, who
> should now verify the return value before dereferencing.
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: linux-scsi@vger.kernel.org
> ---
>  block/scsi_ioctl.c        | 9 ++++++++-
>  drivers/block/paride/pd.c | 2 ++
>  drivers/block/pktcdvd.c   | 2 ++

Acked-by: Jiri Kosina <jkosina@suse.cz>

for the pktdvd.c change.

-- 
Jiri Kosina
SUSE Labs
