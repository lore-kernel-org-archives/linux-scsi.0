From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/6] RFC: beiscsi : handles core routines
Date: Mon, 03 Aug 2009 17:18:31 -0500
Message-ID: <4A776237.6020302@cs.wisc.edu>
References: <20090728071251.GA13581@serverengines.com> <4A7716E9.9060307@cs.wisc.edu> <20090803204131.GV12579@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45449 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbZHCWSl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Aug 2009 18:18:41 -0400
In-Reply-To: <20090803204131.GV12579@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jayamohan Kalickal <jayamohank@serverengines.com>, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Mon, Aug 03 2009, Mike Christie wrote:
>> Hey Jens,
>>
>> Is your block napi code going to go upstream soon? Does it need more  
>> testing or users?
>>
>> This driver is just using a normal old work queue for the completion  
>> path, so I wanted to see about having Jay convert it to your code.
> 
> I plan to include the core bits for 2.6.32, so should be heading to
> mainline soon(ish) :-)
> 

Thanks.

Jay, please look at Jens's block tree
http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=summary
In that tree there is a blk-iopoll branch that you will want to use to 
convert your completion handling to.
