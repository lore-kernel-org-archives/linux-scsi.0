From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraidPERC
 3/Di Container goes offline
Date: Wed, 24 Nov 2004 12:31:36 -0800
Message-ID: <41A4EFA8.5060209@us.ibm.com>
References: <60807403EABEB443939A5A7AA8A7458B694FA8@otce2k01.adaptec.com> <20041124130904.GA12830@infradead.org> <41A4A1B3.5070106@us.ibm.com> <41A4EF0D.7020507@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:41099 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S262835AbUKXUcC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Nov 2004 15:32:02 -0500
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.130])
	by zeus.kernel.org (8.12.11/8.11.6) with ESMTP id iAOKTw8A010080
	for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2004 12:31:56 -0800
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.195.12])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id iAOKQ6FJ052590
	for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2004 15:26:06 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay03.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iAOKQ6FR194838
	for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2004 13:26:06 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id iAOKQ5nK026746
	for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2004 13:26:05 -0700
In-Reply-To: <41A4EF0D.7020507@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: brking@us.ibm.com, Christoph Hellwig <hch@infradead.org>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Ryan Anderson <ryan@autoweb.net>, linux-scsi@vger.kernel.org

Mike Christie wrote:

> Brian King wrote:
> 
>>
>>
>> Christoph Hellwig wrote:
>>
>>> On Wed, Nov 24, 2004 at 07:59:04AM -0500, Salyzyn, Mark wrote:
>>>
>>>> I dropped Andrew Morton from the direct mail recipients.
>>>>
>>>> Thanks, made the change in my branch of the code. This adjustment will
>>>> probably never be submitted to MarkH since I use it only for debugging
>>>> purposes. However, would it be nice if the global scsi timeout could be
>>>> `user' adjustable?
>>>>
>>>> Not that I advocate it as readily accessible, since any storage device
>>>> that takes longer than ten seconds is in `trouble', and any timeout
>>>> longer than two minutes will no doubt cause servers to go offline on 
>>>> the
>>>> internet. Its purpose is only for troubleshooting.
>>>
>>>
>>>
>>>
>>> Yes, it would probably be nice to have a writeable timeout attribute for
>>> the scsi device.  Care to submit a patch?
>>
>>
>>
>> This already exists today.
>>
> 
> Is there any problems with that attr and drivers not being able to handle
> the timeouts someone sets in sysfs. I mean if in my slave_configure I set
> 60 secs becuase for some reason my HW takes this long no matter what, 
> someone
> can reset this to 5 or 1 sec and there are is chance for the lld to 
> override

Sorry, that should have been

"there is no chance"

> this if it is invalid. Is this just one of those things where we say
> only touch the timeout if you know what you are doing, or is it that the 
> lld
> should not have that power, or sometihng else?
> 

