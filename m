From: Mark Lord <liml@rtr.ca>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 15 Apr 2008 09:47:12 -0400
Message-ID: <4804B1E0.10200@rtr.ca>
References: <47E875AD.1000901@rtr.ca>	<47E88A13.70808@zytor.com>	<47E90019.3050006@rtr.ca>	<47E90458.7030801@zytor.com>	<47E9383F.3050908@rtr.ca>	<20080325192515.GA24234@suse.de>	<47E99A02.7040903@rtr.ca>	<47E99EBE.7010708@gmail.com>	<3ae72650803271229h6e188de1t81ccfb64e5d3a214@mail.gmail.com>	<47EBF7D0.6000901@zytor.com>	<e9c3a7c20804111625w68b21b24p6fbd85864713d62f@mail.gmail.com> <20080415001828.b0c9ed64.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760928AbYDONrl@vger.kernel.org>
In-Reply-To: <20080415001828.b0c9ed64.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <htejun@gmail.com>, Mark Lord <lkml@rtr.ca>, Greg KH <gregkh@suse.de>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Andrew Morton wrote:
> On Fri, 11 Apr 2008 16:25:32 -0700 "Dan Williams" <dan.j.williams@intel.com> wrote:
> 
>>>  It doesn't really seem to be to belong under class at all.  I would suggest
>>> /sys/dev/char/ and /sys/dev/block/, for char and block respectively.
>>>
>> This thread fizzled out without a patch... here goes:
>>
>> ...
>>
>> sysfs: add /sys/dev/{char,block} to lookup sysfs path by major:minor
> 
> Crickets are chirping and I can't remember what the conclusion to all this
> was.  In fact the thread was more than ten-deep so I probably fell asleep.
..

Last I recall, Greg was vehemently opposed to having direct path access
by device number in sysfs, but many other people saw benefit.

Myself (the originator), I simply decided that my sysfs access code has
to work with older kernels too, so for now I'm just doing a brute force
tree search to find things in sysfs.  I did get the code size down smaller
for it, but it's still a pain.

When the direct access feature goes in, I'll just change my code to try it first,
and then still fall back to the tree search method on failure.

> I queued it up so that others cannot do the same ;)
..

Good!
