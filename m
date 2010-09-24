From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
 prevent?
Date: Fri, 24 Sep 2010 01:22:17 -0500
Message-ID: <4C9C4399.6080602@hardwarefreak.com>
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BF624.7090906@hardwarefreak.com> <20100924013748.GH13116@bombadil.infradead.org> <4C9C1F95.5000509@hardwarefreak.com> <4C9C37B7.7060204@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:49028 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab0IXGWS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2010 02:22:18 -0400
In-Reply-To: <4C9C37B7.7060204@teksavvy.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Mark Lord put forth on 9/24/2010 12:31 AM:
> On 10-09-23 11:48 PM, Stan Hoeppner wrote:
>> Kyle McMartin put forth on 9/23/2010 8:37 PM:
>>> On Thu, Sep 23, 2010 at 07:51:48PM -0500, Stan Hoeppner wrote:
>>>> ~$ man hdparm
>>>>
>>>
>>> kyle@dreadnought ~ $ hdparm
>>> hdparm - get/set hard disk parameters - version v9.27, by Mark Lord.
>>>                                                         ^^^^^^^^^^^^
>>> [...]
>>
>> Please pardon me while I wipe this egg off my face. :)
>>
>> My apologies Mark.  Please feel free to publicly flog me if you wish.
> 
> Chuckle.  :)
> 
> But you did manage to prompt me to remove that obsolete warning
> from the --security-* commands in hdparm.  They are rather well tested
> at this point in the game.
> 
> hdparm-9.31 is now released, with some fixes to --security,
> and with the nasty warnings mostly removed.
> 
> Thanks!

I guess it's a good thing when one can commit such a public blunder and
still manage to be somewhat helpful?  If so I don't feel 'quite' so
sheepish now.  :)

NOTE to $self:  when you subscribe to Linux dev lists, the odds are
_much_ greater that people who actually write the software you use _are_
the people posting messages.  Perform SENDER_IDENTITY_CHECK and
SANITY_CHECK routines in the future before referring an author to his
own documentation. ;)

-- 
Stan
