From: James Smart <james.smart@avagotech.com>
Subject: Re: [PATCH 03/17] lpfc: Added throttle logging support.
Date: Thu, 17 Dec 2015 07:57:08 -0800
Message-ID: <5672DB54.2090803@avagotech.com>
References: <5671efba.8C/kxNA2eqfImskd%james.smart@avagotech.com>
 <56726EFB.5060707@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35925 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbbLQP5L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2015 10:57:11 -0500
Received: by mail-pa0-f45.google.com with SMTP id q3so24303018pav.3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Dec 2015 07:57:10 -0800 (PST)
In-Reply-To: <56726EFB.5060707@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

The real issue is when extended logging is turned on, which is not there 
by default, then it definitely can become a problem.  I don't doubt 
other drivers hit it too.

I can understand solving this generically and I'm sure there's much 
better people than I to solve the issue at the kernel level.

-- james s


On 12/17/2015 12:14 AM, Hannes Reinecke wrote:
> On 12/17/2015 12:11 AM, James Smart wrote:
>>
>> Implemented a throttle on error logging.
>>
> Weeellll ... that stuff doesn't really belong into the driver.
>
> _If_ that really is an issue it should be moved into a generic helper, 
> as other drivers will have the same problem.
> There also have been quite some discussions at KS about how to handle 
> high-volume logging traffic; also systemd implements its own handling, 
> too.
>
> So it really needs to be discussed separately, and not implemented 
> within a driver.
>
> Cheers,
>
> Hannes

