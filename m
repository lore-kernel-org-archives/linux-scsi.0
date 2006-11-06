From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 6/12] repost: cciss: set sector_size to 2048 for performance
Date: Mon, 6 Nov 2006 21:30:02 +0100
Message-ID: <20061106203001.GF19471@kernel.dk>
References: <20061106202055.GF17847@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:8206 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S1753158AbWKFU1z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2006 15:27:55 -0500
Content-Disposition: inline
In-Reply-To: <20061106202055.GF17847@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Nov 06 2006, Mike Miller (OS Dev) wrote:
> PATCH 6/11
> 
> This patch changes the blk_queue_max_sectors from 512 to 2048. This helps
> increase performance.
> Please consider this for inclusion.

Bad naming - I've never seen sector size refer to anything else but the
actual sector size on the device. Here you use it as the largest
supported command size. To make matters worse, you also export it in the
proc file as such, that's certain to confuse users.

In other news, ack on patch 1-5 so far.

-- 
Jens Axboe

