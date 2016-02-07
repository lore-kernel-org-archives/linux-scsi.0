From: Jens Axboe <axboe@kernel.dk>
Subject: Re: complete boot failure in 4.5-rc1 caused by nvme: make SG_IO
 support optional
Date: Sun, 7 Feb 2016 15:28:55 -0700
Message-ID: <56B7C527.6050300@kernel.dk>
References: <1454783624.2809.6.camel@HansenPartnership.com>
 <20160207092241.GA15331@lst.de>
 <1454861040.2329.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34103 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbcBGW25 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2016 17:28:57 -0500
Received: by mail-pf0-f174.google.com with SMTP id o185so99256493pfb.1
        for <linux-scsi@vger.kernel.org>; Sun, 07 Feb 2016 14:28:57 -0800 (PST)
In-Reply-To: <1454861040.2329.4.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On 02/07/2016 09:04 AM, James Bottomley wrote:
> On Sun, 2016-02-07 at 10:22 +0100, Christoph Hellwig wrote:
>> Keith said it should be on by default, and I promised him to change
>> it once we run into problems, which I guess this counts as.
>>
>> But just curious:  what distro are you using?  Upstream systemd
>> explicitly rejected using scsi_id for NVMe here:
>>
>> 	https://github.com/systemd/systemd/issues/1453
>>
>> and all my test systems don't do this either.
>
> This was SUSE (in my case, openSUSE Leap).  I just checked the source
> package; they patch the by-id rules back in for NVME:
>
> # PATCH-FIX-SUSE 1101-rules-persistent-device-names-for-NVMe-devices.patch (bsc#944132)
> Patch1101:      1101-rules-persistent-device-names-for-NVMe-devices.patch
>
> The bugzilla is giving access denied for bug id 944132, so it's likely
> some proprietary vendor problem.  The patch has no preamble, so it's
> hard to tell what they were thinking.

I run root-on-nvme on my laptop, and I haven't observed any problems. 
Generally I hate for options to default y unless absolutely necessary, 
it's a sure fire way to feature creep your kernel without noticing. I 
don't think getting all hot about this issue is fair, if the only known 
case is suse.

If anything, let's make the description better. It's trying to be funny, 
it'd be better if it was descriptive and covered this case as well.

-- 
Jens Axboe

