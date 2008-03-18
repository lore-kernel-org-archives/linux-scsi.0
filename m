From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device
 causes infinite loop in 2.6.24
Date: Tue, 18 Mar 2008 11:52:57 -0500
Message-ID: <47DFF369.90805@sgi.com>
References: <47D7035F.5000700@sgi.com> <47D7B4A1.6020909@panasas.com> <47D7FECE.1020901@sgi.com> <47D8002C.9010306@panasas.com> <47DA798E.5080305@sgi.com> <47DFE9E4.6070301@sgi.com> <47DFEBBD.7080702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.171.30]:57681 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756665AbYCSTgB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 15:36:01 -0400
In-Reply-To: <47DFEBBD.7080702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>



Boaz Harrosh wrote:
> On Tue, Mar 18 2008 at 18:12 +0200, Michael Reed <mdr@sgi.com> wrote:
>> Michael Reed wrote:
>>> Boaz Harrosh wrote:
>>> <snip>
>>>>>> Just to demonstrate what I mean a patch is attached. Just as an RFC, totally
>>>>>> untested.
>>>>> I can try this out and see what happens.
>>>>>
>>>>>
>>>> Will not compile here is a cleaner one
>>> Still in my queue.  Hopefully I'll get to poke at this today.
>> Patch compiles cleanly and appears to have no effect on the misc.
>> sg_* commands I've executed including sg_dd, sg_inq, sg_luns, sg_readcap.
>>
>> Mike
>>
>>> Mike
>>>
> <patch sniped>
> 
> If you remove the original fix to sg.c
> ([PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device causes infinite loop in 2.6.24)
> 
> and apply this patch, does it solve your original infinite loop?

Unfortunately, the infinite loop only occurred at 2.6.24.  I'll see if
I can break the current rc by removing some known fixes.

Care to gen a patch for 2.6.24?

Mike

> 
> Thanks
> Boaz
> 
