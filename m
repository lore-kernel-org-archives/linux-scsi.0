From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
 prevent?
Date: Fri, 24 Sep 2010 01:02:17 -0400
Message-ID: <4C9C30D9.8090302@interlog.com>
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BF624.7090906@hardwarefreak.com> <20100924013748.GH13116@bombadil.infradead.org> <4C9C1F95.5000509@hardwarefreak.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C9C1F95.5000509@hardwarefreak.com>
Sender: linux-ide-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Mark Lord <kernel@teksavvy.com>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 10-09-23 11:48 PM, Stan Hoeppner wrote:
> Kyle McMartin put forth on 9/23/2010 8:37 PM:
>> On Thu, Sep 23, 2010 at 07:51:48PM -0500, Stan Hoeppner wrote:
>>> ~$ man hdparm
>>>
>>
>> kyle@dreadnought ~ $ hdparm
>> hdparm - get/set hard disk parameters - version v9.27, by Mark Lord.
>>                                                         ^^^^^^^^^^^^
>> [...]
>
> Please pardon me while I wipe this egg off my face. :)
>
> My apologies Mark.  Please feel free to publicly flog me if you wish.

I wonder if Mark every watched a program called
Sledge Hammer! whose signature line was "Trust me.
I know what I'm doing." Recently I needed to plead
with hdparm to corrupt a sector as follows:

# hdparm --make-bad-sector 976770000 --yes-i-know-what-i-am-doing /dev/sdb

Doug Gilbert
