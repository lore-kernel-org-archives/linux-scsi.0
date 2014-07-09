From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: scsi-mq V2
Date: Wed, 09 Jul 2014 12:39:29 -0400
Message-ID: <53BD7041.5010300@interlog.com>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <20140708144829.GA5539@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140708144829.GA5539@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 14-07-08 10:48 AM, Christoph Hellwig wrote:
> On Wed, Jun 25, 2014 at 06:51:47PM +0200, Christoph Hellwig wrote:
>> Changes from V1:
>>   - rebased on top of the core-for-3.17 branch, most notable the
>>     scsi logging changes
>>   - fixed handling of cmd_list to prevent crashes for some heavy
>>     workloads
>>   - fixed incorrect handling of !target->can_queue
>>   - avoid scheduling a workqueue on I/O completions when no queues
>>     are congested
>>
>> In addition to the patches in this thread there also is a git available at:
>>
>> 	git://git.infradead.org/users/hch/scsi.git scsi-mq.2
>
>
> I've pushed out a new scsi-mq.3 branch, which has been rebased on the
> latest core-for-3.17 tree + the "RFC: clean up command setup" series
> from June 29th.  Robert Elliot found a problem with not fully zeroed
> out UNMAP CDBs, which is fixed by the saner discard handling in that
> series.
>
> There is a new patch to factor the code from the above series for
> blk-mq use, which I've attached below.  Besides that the only changes
> are minor merge fixups in the main blk-mq usage patch.

Be warned: both Rob Elliott and I can easily break
the scsi-mq.3 branch. It seems as though a regression
has slipped in. I notice that Christoph has added a
new branch called "scsi-mq.3-no-rebase".

For those interested, watch this space.

Doug Gilbert
