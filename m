From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] make kernel ignore bogus partitions
Date: Mon, 8 May 2006 22:20:26 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0605082214581.20743@yvahk01.tjqt.qr>
References: <20060503210055.GB31048@beardog.cca.cpqcorp.net>
 <20060508072701.GB15941@apps.cwi.nl> <445F64E2.3000902@dgreaves.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux01.gwdg.de ([134.76.13.21]:50104 "EHLO linux01.gwdg.de")
	by vger.kernel.org with ESMTP id S1751302AbWEHUVD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2006 16:21:03 -0400
In-Reply-To: <445F64E2.3000902@dgreaves.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Andries Brouwer <Andries.Brouwer@cwi.nl>, "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>> Sometimes partitions claim to be larger than the reported capacity of a
>>> disk device. This patch makes the kernel ignore those partitions.
>>>     
>> Or, while doing forensics on a disk one copies the start to some
>> other disk, and that other disk may be smaller.
>> Etc.
>>
>> So, it seems that Linux loses a little bit of its power when such things
>> are made impossible.
>>   
>I've had similar situations when trying to recover data from failed devices.
>Equally - if you don't know what's going on then partition/disk size
>mismatch is a bad thing.
>A loud warning may be more appropriate (and useful) than an ignore.

I also consider a warning message more helpful.
OTOH, what if the disk will be automounted at boot? The boot scripts 
won't catch it if it just a warning, whereas if it was ignored, no mount 
would occur.
Maybe a bootparam toggling warning/ignore as the solution?


Jan Engelhardt
-- 
