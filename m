From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH 0/5] Feature enhancements for ses module
Date: Wed, 22 Oct 2014 13:12:01 -0600
Message-ID: <54480181.1010001@fb.com>
References: <1408987546-2418-1-git-send-email-songliubraving@fb.com> <C709E4D363AAB64590BFAC54D4C478AAEBC4ABA5@PRN-MBX02-4.TheFacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56928 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462AbaJVTM2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2014 15:12:28 -0400
In-Reply-To: <C709E4D363AAB64590BFAC54D4C478AAEBC4ABA5@PRN-MBX02-4.TheFacebook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@infradead.org>

On 08/25/2014 11:34 AM, Song Liu wrote:
> From: Song Liu [mailto:songliubraving@fb.com] 
> Sent: Monday, August 25, 2014 10:26 AM
> To: Song Liu
> Subject: [PATCH 0/5] Feature enhancements for ses module
> 
> These patches include a few enhancements to ses module:
> 
> 1: close potential race condition by at enclosure race condition
> 
> 2,3,4: add enclosure id and device slot, so we can create symlink
>        in /dev/disk/by-slot:
>   # ls -d /dev/disk/by-slot/*
>     /dev/disk/by-slot/enclosure-0x5000ae41fc1310ff-slot0
> 
> 5: add ability to power on/off device with power_status file in
>    sysfs.
> 
> Dan Williams (4):
>   SES: close potential registration race
>   SES: generate KOBJ_CHANGE on enclosure attach
>   SES: add enclosure logical id
>   SES: add reliable slot attribute
> 
> Song Liu (1):
>   SES: Add power_status to SES enclosure component

Guys, where are we with these? Seemed like they got reviewed (and
updates/fixes posted), then nothing else happened. Would be nice to get
these upstream, so we don't have to carry them at FB.

-- 
Jens Axboe

