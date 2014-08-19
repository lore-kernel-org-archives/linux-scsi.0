From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: Re: [PATCH 13/14] scsi: add support for a blk-mq based I/O path.
Date: Tue, 19 Aug 2014 21:41:01 +0530
Message-ID: <CAHsXFKGS-=m0SByVXxdEeK+Mnnf93tPf+x+5Y-rTuR2auQXf+w@mail.gmail.com>
References: <1405678393-11497-1-git-send-email-hch@lst.de>
	<1405678393-11497-14-git-send-email-hch@lst.de>
	<885d029677826efe0cfe3803411cbdba@mail.gmail.com>
	<20140819160625.GA29770@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140819160625.GA29770@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 19, 2014 at 9:36 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Tue, Aug 19, 2014 at 03:51:42AM +0530, Kashyap Desai wrote:
>> I read  this comment and find that very few drivers are using this
>> cmd_list.  I think if we remove this cmd_list, performance will scale as I
>> am seeing major contention in this lock.
>> Just thought to ping you to see if this is known limitation for now or any
>> plan to change this lock in near future ?
>
> Removing the lock entirely and pushing the list into the two drivers
> using it is on my TODO list.  Bart actually suggested keeping the code in the
> SCSI core and having a flag to enabled.  Given that I'm too busy to get my full
> version done in time, it might be a good idea if someone picks up Barts
> idea.  Can you send me a patch to add a enable_cmd_list flag to the host
> template and only enable it for aacraid and dpt_i2o?
>

Sure. I will work on relevant code change and will post patch for review.

-- 
Device Driver Developer @ Avagotech
Kashyap D. Desai
Note - my new email address
kashyap.desai@avagotech.com
