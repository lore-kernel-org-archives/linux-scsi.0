From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] allow displaying and setting of cache type via sysfs
Date: Thu, 23 Mar 2006 11:18:37 +0100
Message-ID: <20060323101836.GW4285@suse.de>
References: <1142712861.3773.6.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:12113 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S932170AbWCWKSb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Mar 2006 05:18:31 -0500
Content-Disposition: inline
In-Reply-To: <1142712861.3773.6.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, Mar 18 2006, James Bottomley wrote:
> I think I promised to do this two years ago
> 
> This patch adds a scsi_disk class with the cache type and FUA
> parameters, so user land application can easily obtain them without
> having to parse dmesg.  It also allows setting the cache type (use with
> care...)
> 
> This patch is a bit dangerous because I've replaced the disk kref with a
> class device reference ...

Woo, thanks James :-)

-- 
Jens Axboe

