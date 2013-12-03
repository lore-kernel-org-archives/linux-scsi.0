From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: Re: [PATCH] drivers: scsi: scsi_lib.c: add prefix "SCSILIB_" to macro
 "SP"
Date: Tue, 03 Dec 2013 19:42:01 +0800
Message-ID: <529DC389.6060102@gmail.com>
References: <528AEFB7.4060301@gmail.com> <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com> <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com> <52955913.3060809@gmail.com> <529B60FF.7030601@acm.org> <529BD584.7060504@gmail.com> <1385945387.20150.2.camel@dabdike.int.hansenpartnership.com> <529C5D89.8050809@gmail.com> <20131202213243.GA20646@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38324 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3LCLmG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2013 06:42:06 -0500
In-Reply-To: <20131202213243.GA20646@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rkuo <rkuo@codeaurora.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@acm.org>, Bottomley@parallels.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 12/03/2013 05:32 AM, rkuo wrote:
> On Mon, Dec 02, 2013 at 06:14:33PM +0800, Chen Gang wrote:
>> If one issue occurs, normally, both sides need improvement.
>>
>> For our issue:
>>
>>  - need try to keep uapi no touch ("arch/hexagon/uapi/asm/registers.h").
>>
>>  - improving our module is much easier than improving hexagon.
>>
>>  - for 'SP', it is really short enough to like a register name.
>>    SG_POOL seems more suitable for our 'sgpool' related operations.
>>
>>
>> It will be better to improve hexagon too, but it is not quit easy (maybe
>> have to bear it), it is uapi :-(
> 
> I can't speak for SCSI, but that define in Hexagon isn't really used outside
> of that file anyways (the two SP macros themselves).  I'm also pretty sure
> the userspace isn't currently using it anyways.  Seeing as it's not really
> buying us anything, I'm fine with just removing it and continuing to review
> the other defines.  I'll make that change and test it locally.
> 

OK, thanks.

> 
> Thanks,
> Richard Kuo
> 
> 


-- 
Chen Gang
