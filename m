From: Matt Tehonica <matt.tehonica@mac.com>
Subject: Re: Applying MVSAS Patch
Date: Mon, 21 Dec 2009 13:20:23 -0500
Message-ID: <D58EC6A0-FA57-470F-9369-83D8FFA39FF5@mac.com>
References: <67980649284293627495293095942659870934-Webmail@me.com>
 <20091216081301.59d1698e.randy.dunlap@oracle.com>
 <93017718277361587250366956065608636194-Webmail@me.com>
 <20091216090430.66b7f389.randy.dunlap@oracle.com>
 <29479280-86A1-4DF5-BA64-F2F0F1A4838B@mac.com>
 <20091216101617.a6499cad.randy.dunlap@oracle.com>
 <105495033028979535461096937726809251647-Webmail@me.com>
 <alpine.DEB.1.10.0912181519510.23464@uplift.swm.pp.se>
 <4D393076-4B36-49EC-AA69-ED0E52298943@mac.com>
 <5FF020A1CFFEEC49BD1E09530C4FF59505601D4D34@SC-VEXCH1.marvell.com>
 <alpine.DEB.1.10.0912211305180.23464@uplift.swm.pp.se>
 <17117.87.210.74.220.1261398332.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from asmtpout017.mac.com ([17.148.16.92]:38571 "EHLO
	asmtpout017.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbZLUSUd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2009 13:20:33 -0500
Received: from [192.168.1.111]
 (cpe-74-71-154-226.twcny.res.rr.com [74.71.154.226])
 by asmtp017.mac.com (Sun Java(tm) System Messaging Server 6.3-8.01 (built Dec
 16 2008; 32bit)) with ESMTPSA id <0KV00018ILM0JY40@asmtp017.mac.com> for
 linux-scsi@vger.kernel.org; Mon, 21 Dec 2009 10:20:30 -0800 (PST)
In-reply-to: <17117.87.210.74.220.1261398332.squirrel@ketsers.dhs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Caspar Smit <caspar@ketsers.dhs.org>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Andy Yan <ayan@marvell.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On Dec 21, 2009, at 7:25 AM, Caspar Smit <caspar@ketsers.dhs.org> wrote:

>> On Sun, 20 Dec 2009, Andy Yan wrote:
>>
>>> Please don't apply the 7th patch with your kernel.
>>
>> Any chance of getting your patch applied to the stable kernel tree  
>> so it
>> might come into the regular distribution kernels?
>>
>> Might be good to hear if the other people applying it have had  
>> better luck
>> than me, for me the patches made the kernel freeze as soon as I did
>> anything with the mvsas device in question.
>
> Same here, after applying patches 1-6 at vanilla 2.6.32, the raid5/6
> disconnecting of disks disappeared but still way too unstable. Kernel
> panics when hotplugging exists and being able to run 3 controllers  
> at the
> same time is impossible.
>
> Caspar
>
>>
>> --
>> Mikael Abrahamsson    email: swmike@swm.pp.se
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Yeah I have same problems with these patches. Gets the card to work  
but can't hotplug. 
