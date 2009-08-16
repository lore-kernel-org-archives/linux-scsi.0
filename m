From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Sat, 15 Aug 2009 23:25:29 -0400
Message-ID: <4A877C29.1070706@rtr.ca>
References: <20090816004705.GA7347@infradead.org> <4A876255.10606@rtr.ca> <4A876CA9.20906@rtr.ca> <20090816022500.GA12392@infradead.org> <4A8773C4.6030409@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:52282 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbZHPDZa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Aug 2009 23:25:30 -0400
In-Reply-To: <4A8773C4.6030409@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com

Mark Lord wrote:
> Christoph Hellwig wrote:
>> On Sat, Aug 15, 2009 at 10:19:21PM -0400, Mark Lord wrote:
>>> Mark Lord wrote:
>>>> Christoph Hellwig wrote:
>>> ..
>>>>> Mark, any chance to try it?  Just create an XFS filesystem, age it a
>>>>> bit and then call the attached little trim.c program on the mountmoint
>>>>> (or any file inside the filesystem for that matter)
>>>> ..
>>>>
>>>> Looking at it now.  Thanks, Christoph!
>>> ..
>>>
>>> Fails to work on 64-bit kernel w/ 32-bit userspace (no compat ioctl).
>>> Rebuilding with 32-bit kernel now..
>>
>> The actual ioctl is compatible, just add the
>>
>>     case XFS_IOC_TRIM:
>>         return xfs_ioc_trim(mp, arg);
>>
>> to xfs_file_compat_ioctl().  I'll add this to the next spin of the patch.
> ..
> 
> Peachy.  Rebuilding again now..
> 
> Don't wait up for this .. I'll finish it on Sunday.  Bedtime.  :)
..

Mmm.. doesn't work on stock 2.6.31-rc6.
It must also require Matthew's patches for discard/trim support.

Later.

