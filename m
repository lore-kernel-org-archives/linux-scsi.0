From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH UPDATED] block: In blk_execute_rq_nowait, init rq->end_io
 before checking for dead queue.
Date: Sun, 10 Jun 2012 17:40:54 +0000
Message-ID: <4FD4DC26.5080902@acm.org>
References: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com> <4FD345DC.6020405@acm.org> <CAFR8ueca-MQWRipE+3OQSpqmJ40HKJEY7jWt6PQ+zTCQ9Bh=5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFR8ueca-MQWRipE+3OQSpqmJ40HKJEY7jWt6PQ+zTCQ9Bh=5Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/09/12 23:57, Muthu Kumar wrote:

> Locking change is the one you posted already (the link above). Anyway,
> I have the attached patch *including* the locking change. Original
> mail has attachment without locking change. Please use whatever you
> need.


While we are at it ... the rq->rq_disk and rq->end_io assignments can be
performed safely before the spinlock is taken, isn't it ?

Bart.
