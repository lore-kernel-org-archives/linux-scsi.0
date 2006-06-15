From: Jens Axboe <axboe@suse.de>
Subject: Re: IO blocks are limited to 512KBytes (blk_queue_max_sectors)
Date: Thu, 15 Jun 2006 20:57:46 +0200
Message-ID: <20060615185746.GG3456@suse.de>
References: <44917313.9040800@ext.bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:39997 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1030788AbWFOS5F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 14:57:05 -0400
Content-Disposition: inline
In-Reply-To: <44917313.9040800@ext.bull.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Thu, Jun 15 2006, Frederic TEMPORELLI wrote:
> So, what is the nice way to change the block layer for getting large IO 
> blocks (> 1024 sectors) ?

# echo large_value > /sys/block/<dev>/queue/max_sectors_kb

where large_value <= max_hw_sectors_kb

-- 
Jens Axboe

