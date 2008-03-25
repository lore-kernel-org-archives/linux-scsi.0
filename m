From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Mon, 24 Mar 2008 22:13:55 -0700
Message-ID: <47E88A13.70808@zytor.com>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:56504 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbYCYFO1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Mar 2008 01:14:27 -0400
In-Reply-To: <47E87942.2020409@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Mark Lord wrote:
> 
> One candidate might seem to be the existing /sys/block/dev/partition/start
> which I expect is already 64-bit friendly.
> 
> But this requires about 150 lines of somewhat complex C code to access,
> using only the dev_t (from stat(2) on a file) as a starting point,
> or less if one relies upon the udev device name matching the sysfs 
> device name.
> 
> Is it time now for HDIO_GETGEO64 to make an appearance?
> Similar to how the existing BLKGETSIZE64 is supplanting BLKGETSIZE ?
> 

Probably a better thing to have would be a way to look up block devices 
in sysfs by device number.

	-hpa
