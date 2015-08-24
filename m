From: Don Brace <brace77070@gmail.com>
Subject: Re: [BUG] hpsa: Controller lockup detected: 0x00150028
Date: Mon, 24 Aug 2015 09:11:31 -0500
Message-ID: <55DB2613.4050702@pmcs.com>
References: <20150518124058.GH21418@twins.programming.kicks-ass.net>
 <EC48209BE0009041A0D3C6A996EAD2AE27A7FAEE@G9W0754.americas.hpqcorp.net>
 <20150518152034.GC5404@twins.programming.kicks-ass.net>
 <20150518160345.GA18673@twins.programming.kicks-ass.net>
 <20150518161146.GB18673@twins.programming.kicks-ass.net>
 <555F46F4.2090002@redhat.com>
 <20150522164002.GJ3644@twins.programming.kicks-ass.net>
 <2C438B34CAC8264398F5C7AF7411910A6347343E@G9W0731.americas.hpqcorp.net>
 <loom.20150824T113849-717@post.gmane.org>
 <loom.20150824T115915-623@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:34898 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbbHXOLd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2015 10:11:33 -0400
Received: by obbwr7 with SMTP id wr7so114129382obb.2
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2015 07:11:32 -0700 (PDT)
In-Reply-To: <loom.20150824T115915-623@post.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wouter Depuydt <wouter.depuydt@gmail.com>, linux-scsi@vger.kernel.org


On 08/24/2015 05:02 AM, Wouter Depuydt wrote:
> Wouter Depuydt <wouter.depuydt <at> gmail.com> writes:
>
>>> -----Original Message-----
>>> From: Peter Zijlstra [mailto:peterz <at> infradead.org]
>>> Sent: Friday, May 22, 2015 11:40 AM
>>> To: Tomas Henzl
>>> Cc: Oelke, Mark; don.brace <at> pmcs.com; ISS StorageDev; storagedev <at>
>> pmcs.com; linux-scsi <at> vger.kernel.org
>>> Subject: Re: [BUG] hpsa: Controller lockup detected: 0x00150028
>>>
>>> On Fri, May 22, 2015 at 05:10:44PM +0200, Tomas Henzl wrote:
>>>>>> I've updated to 6.62 and it appears to be working now; or rather,
> it has
>>> I've since gotten 6.64 from HP to test; which does not seem public yet.
>>>
>>> 6.64 actually fixes the issue for me.
>>>
>> Hi everone,
>>
>> I've experienced a similar problem with a P411 controller in HBA mode.
>> Serial Number	PDNMH0ARH8P04A
>> Model	HP Smart Array P441 Controller
>> Firmware Version	2.52
>>
> Other System info:
>
> HP Proliant D380p Gen9
> Ubuntu LTS 14.04
> ii  linux-image-3.19.0-26-generic
> ii  linux-image-extra-3.19.0-26-generic
> ii  linux-image-generic-lts-vivid
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
I see this issue addressed in the Firmware update page under the "Fixes" 
tab.
http://h20564.www2.hpe.com/hpsc/swd/public/detail?sp4ts.oid=3984645&swItemId=MTX_55b304486f544f148de6c5cc6e&swEnvOid=4103#tab4


Problems Fixed:

     Running SMARTCTL (smartmontools) on HP Proliant G6/G7 (Px1x) Smart 
Array controllers that have firmware version 5.70 to 6.62 installed with 
SATA drives attached may result in system not responding or reboot. Wehn 
reboot occurred, a reboot 1719 POST error message with lockup 0x15 
displayed.

Hope this helps you.


