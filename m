From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] change scsi_cmd_ioctl to take a gendisk instead of a queue
Date: Mon, 2 Feb 2004 14:27:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040202132747.GN11683@suse.de>
References: <20040201124803.A18050@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:50365 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S265689AbUBBN1z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2004 08:27:55 -0500
Content-Disposition: inline
In-Reply-To: <20040201124803.A18050@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Feb 01 2004, Patrick Mansfield wrote:
> Jens or others, any comments?
> 
> This patch against a recent bk 2.6 changes scsi_cmd_ioctl to take a
> gendisk as an argument instead of a request_queue_t. This allows scsi char
> devices to use the scsi_cmd_ioctl interface.
>  
> In turn, change bio_map_user to also pass a request_queue_t, and add a
> __bio_add_page helper that takes a request_queue_t.
> 
> Tested ide cd burning with no problems.
> 
> If the scsi upper level scsi_cmd_ioctl usage were consolidated in
> scsi_prep_fn, we could pass a request_queue_t instead of a gendisk to
> scsi_cmd_ioctl.

Looks fine to me.

-- 
Jens Axboe

