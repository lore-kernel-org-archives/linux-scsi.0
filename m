From: Tom Rini <trini@ti.com>
Subject: Re: Commit a692b0e broke my mvsas card
Date: Mon, 16 Apr 2012 18:53:16 -0700
Message-ID: <4F8CCD0C.5060900@ti.com>
References: <20120416224250.GA1983@bill-the-cat>	 <CABE8wwvbSsc02U_m+20-DQgsZ2gQCi_A6susCrmfyx_scQkccw@mail.gmail.com>	 <4F8CAC6F.6070907@ti.com> <1334620782.23541.2.camel@ultramagnus.opencreations.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:45342 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab2DQBxV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Apr 2012 21:53:21 -0400
In-Reply-To: <1334620782.23541.2.camel@ultramagnus.opencreations.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <JBottomley@parallels.com>, Xiangliang Yu <yuxiangl@marvell.com>

On 04/16/2012 04:59 PM, Dan Williams wrote:
> On Mon, 2012-04-16 at 16:34 -0700, Tom Rini wrote:
>> On 04/16/2012 04:12 PM, Dan Williams wrote:
>>> On Mon, Apr 16, 2012 at 3:42 PM, Tom Rini<trini@ti.com>   wrote:
>>>> Hey all,
>>>>
>>>> I have an OCZ RevoDrive3 X2 (which the mvsas driver works for).  I've
>>>> been running mainline since support for my card was added and I just
>>>> went to test 3.3-rc4.  Unpatched I get some sort of recursive fault that
>>>
>>> I assume this was supposed to be 3.4-rc3?
>>
>> Yes, sorry.
>>
>>>> locks up the system.  When I revert a692b0e (which I found with a git
>>>> bisect) things are working as expected again.  What info do you need
>>>> from me to work out the right solution here?  Thanks!
>>>
>>> Can you post the kernel log of the fault (starting at the first sign
>>> of trouble)?
>>>
>>> I suspect it's one of the known regression fixes [1], but would like
>>> to double check.
>>
>> I merged those changes in and the problem is now non-fatal but now I'm
>> missing 2 of the 4 drives on the card.  Portion of dmesg is at
>> http://pastebin.com/36K7xwHK and I can email it if needed.
>>
>
> Thanks, yes it looks like a new regression.  Can you tell me if the
> following fixes it?

No joy, oopses.  http://alnk.org/43youngkirby for the dmesg and oops.

-- 
Tom
