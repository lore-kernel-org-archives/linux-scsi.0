From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: [PATCH] Avoid that a kernel warning appears during system resume
Date: Sun, 17 Mar 2019 15:20:06 +0100
Message-ID: <2683612.6HTjCspbsH@merkaba>
References: <20190315232758.221199-1-bvanassche@acm.org> <4337330.mz4Gj9yf0O@merkaba> <7436af16-0e46-418f-cfec-1ae530b2a82a@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <7436af16-0e46-418f-cfec-1ae530b2a82a@acm.org>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Oleksandr Natalenko <oleksandr@natalenko.name>, stable@vger.kernel.org, Jisheng Zhang <Jisheng.Zhang@synaptics.com>
List-Id: linux-scsi@vger.kernel.org

Hi Bart.

Bart Van Assche - 16.03.19, 22:28:
> On 3/16/19 3:43 AM, Martin Steigerwald wrote:
> > Bart Van Assche - 16.03.19, 00:27:
> >> Since scsi_device_quiesce() skips SCSI devices that have another
> >> state than RUNNING, OFFLINE or TRANSPORT_OFFLINE,
> >> scsi_device_resume() should not complain about SCSI devices that
> >> have been skipped. Hence this patch. This patch avoids that the
> >> following warning appears> 
> >> during resume:
> > Am I on CC cause one of those warnings appeared in bug reports from
> > me from quite some time ago?
[…]
> That's correct. I hope that you don't mind that I cc'ed you?

No, I don't mind.

Would you like me to apply the patch in order to test it? As it is just 
about suppressing a kernel warning and not changing any major 
functionality, I wondered whether you like me to do with this or whether 
the CC is more JFYI.

> >> WARNING: CPU: 3 PID: 1039 at blk_clear_pm_only+0x2a/0x30
> >> CPU: 3 PID: 1039 Comm: kworker/u8:49 Not tainted 5.0.0+ #1
> >> Hardware name: LENOVO 4180F42/4180F42, BIOS 83ET75WW (1.45 )
> > 
> > This at least does not appear to be this ThinkPad T520, as I have
> > BIOS version 1.49 already.
> 
> The call trace in the patch description is only an example. I think
> the problem description and the patch applies to all systems that
> have one or more SCSI disks.

Best,
-- 
Martin
