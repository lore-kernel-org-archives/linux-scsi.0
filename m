From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] add SCSI reset ioctls to scsi_ioctl.c (and sd and sr)
Date: Sat, 18 Sep 2004 22:49:44 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0409182238070.2555@kai.makisara.local>
References: <1095526671.2483.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:64686 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S269620AbUIRTtq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Sep 2004 15:49:46 -0400
In-Reply-To: <1095526671.2483.5.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Sat, 18 Sep 2004, James Bottomley wrote:

> The purpose of this patch is to allow a SCSI reset to be issued directly
> to the devices without having to go via sg.  Because the reset may be
> issued even while the device is in recovery, this had to be done via a
> new api (sd won't invoke scsi_ioctl() while the device is in recovery).
> 
> Kai, do you want me to plum this into st as well?
> 
Yes, please do that. I would like st to have the same generic capabilities 
as the other high-level drivers as far as possible and I don't see any 
problems in adding this feature. It is useful to have an easy way to reset 
a tape drive. Some drives seem to be lock up easily when they see a bad tape.

-- 
Kai
