From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND 0/6] hpsa: support legacy boards
Date: Fri, 11 Aug 2017 08:43:21 +0200
Message-ID: <6b439024-3bda-c370-b32b-d0fba67efbd9@suse.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
 <4993A297653ECB4581FA5C3C31323D195B8C9FAB@avsrvexchmbx2.microsemi.net>
 <271fd4b5-046f-2c74-4af8-60f225744313@suse.de>
 <20170810070904.GA20910@lst.de>
 <1502374013.2736.11.camel@HansenPartnership.com>
 <8d4fdf1c-bdd6-3069-1933-a031c84811c6@suse.de>
 <4993A297653ECB4581FA5C3C31323D195B8CACF5@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50457 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751299AbdHKGnX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Aug 2017 02:43:23 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D195B8CACF5@avsrvexchmbx2.microsemi.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Meelis Roos <mroos@linux.ee>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 08/10/2017 09:15 PM, Don Brace wrote:
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Thursday, August 10, 2017 9:11 AM
>> To: James Bottomley <James.Bottomley@HansenPartnership.com>;
>> Christoph Hellwig <hch@lst.de>
>> Cc: Don Brace <don.brace@microsemi.com>; Martin K. Petersen
>> <martin.petersen@oracle.com>; Meelis Roos <mroos@linux.ee>; linux-
>> scsi@vger.kernel.org
>> Subject: Re: [PATCH RESEND 0/6] hpsa: support legacy boards
>>
>> EXTERNAL EMAIL
>>
>>
>> On 08/10/2017 04:06 PM, James Bottomley wrote:
>>> On Thu, 2017-08-10 at 09:09 +0200, Christoph Hellwig wrote:
>>>> No device support in Linux is unsupported, sorry.  I think we're
>>>> getting into the corporate bullshit game a little too much here.
>>>
>>> I think there are two different definitions of supported here.  To us,
>>> any device to which the driver attaches is "supported".  However, if
>>> it's never been tested before it may not work very well.  In the Linux
>>> way, we'll try to fix the bugs when they're reported and in that sense
>>> we support the device until nothing in the kernel attaches to its ids
>>> anymore.
>>>
>>> In the corporate world "supported" means we'll sell you a contract
>>> giving you certain rights to report bugs and have us fix them.  There
>>> are definite reasons why corporations only support a small range of new
>>> devices, even though devices not on this list may still be attached to
>>> by the driver and thus we (Linux Community) would try to fix the bug
>>> reports for.
>>>
>>> I think what you're basically asking for is a different name for the
>>> flag, which is fine?  how about 'legacy' instead?
>>>
>> Sure, no problem with that.
>>
>> Don?
>>
>> Cheers,
>>
>> Hannes
>> --
>> Dr. Hannes Reinecke                Teamlead Storage & Networking
>> hare@suse.de                                   +49 911 74053 688
>> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
>> GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
>> HRB 21284 (AG Nürnberg)
> 
> Ok, but to clarify...
>  * Will the cciss driver be removed when these patches are applied? Otherwise
>     what will prevent the cciss driver from loading over these devices?
>     i.e. how often will users need to be reminded to add cciss.cciss_allow_hpsa flag?
> 
> 
The idea is to remove the cciss driver completely once these changes are
in. Preferably with the same patchset to avoid any timing issues.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
