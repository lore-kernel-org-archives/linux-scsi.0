From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 25 Mar 2008 06:55:36 -0700
Message-ID: <47E90458.7030801@zytor.com>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca> <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47E90019.3050006@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: Greg KH <gregkh@suse.de>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
> 
> Yeah, that would be just as good, really.  Maybe even better.
> 
> Mark Lord wrote (later on):
>> Instead, software has to search everything inside /sys/block/
>> looking for a "dev" file whose contents match,
>> rather than just trying to access something like this:
>>
>>   /sys/block/8:1/start
>> or
>>   /sys/block/majors/8/minors/1/start
>>
>> Or any one of a number of similar ways to arrange it. 
> ..
> 

It shouldn't be under /sys/block... there are enough many things that 
scan /sys/block and assume any directory underneath it has the current 
format.

	-hpa
