From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] REQ_BLOCK_PC only returns SCSI status byte
Date: Thu, 25 Sep 2003 21:51:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030925195151.GL15415@suse.de>
References: <20030925111848.A26884@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:39111 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261670AbTIYTw7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2003 15:52:59 -0400
Content-Disposition: inline
In-Reply-To: <20030925111848.A26884@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Thu, Sep 25 2003, Patrick Mansfield wrote:
> Jens/James -
> 
> Can you please apply or comment?
> 
> Only the low byte of the linux scsi result is being returned for
> REQ_BLOCK_PC usage. This means driver errors such as DID_ERROR are not
> returned to user space.
> 
> The ide-cd.c code looks like it should be OK with this patch, but I did
> not test it. I tested using SG_IO to an sd, for the case of DID_ERROR
> coming back from the qlogic adapter (with underflow set, it was returning
> DID_ERROR).

Patch looks fine to me, applied.

-- 
Jens Axboe

