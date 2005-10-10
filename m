From: Jens Axboe <axboe@suse.de>
Subject: Re: ioctl for max_sectors
Date: Mon, 10 Oct 2005 16:16:00 +0200
Message-ID: <20051010141559.GD7232@suse.de>
References: <4349F067.1010007@cdac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:8215 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1750808AbVJJOPd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Oct 2005 10:15:33 -0400
Content-Disposition: inline
In-Reply-To: <4349F067.1010007@cdac.in>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karthik Sarangan <karthiks@cdac.in>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Oct 10 2005, Karthik Sarangan wrote:
> With what ioctl can I retrieve the max_sectors count of struct 
> Scsi_Host_Template?

You don't, see /sys/block/sdX/queue/max_sectors_kb and
max_hw_sectors_kb. The latter is the hardware advertised max value, the
former is the one the block layer uses. You can only change the former,
which can of course never exceed the latter.

-- 
Jens Axboe

