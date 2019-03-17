From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Avoid that a kernel warning appears during system resume
Date: Sun, 17 Mar 2019 10:19:52 -0700
Message-ID: <b2a68e82-492d-d580-71fe-3ca110a3f0f4@acm.org>
References: <20190315232758.221199-1-bvanassche@acm.org>
 <4337330.mz4Gj9yf0O@merkaba> <7436af16-0e46-418f-cfec-1ae530b2a82a@acm.org>
 <2683612.6HTjCspbsH@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <2683612.6HTjCspbsH@merkaba>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Oleksandr Natalenko <oleksandr@natalenko.name>, stable@vger.kernel.org, Jisheng Zhang <Jisheng.Zhang@synaptics.com>
List-Id: linux-scsi@vger.kernel.org

On 3/17/19 7:20 AM, Martin Steigerwald wrote:
> Bart Van Assche - 16.03.19, 22:28:
>> On 3/16/19 3:43 AM, Martin Steigerwald wrote:
>>> Bart Van Assche - 16.03.19, 00:27:
>>>> Since scsi_device_quiesce() skips SCSI devices that have another
>>>> state than RUNNING, OFFLINE or TRANSPORT_OFFLINE,
>>>> scsi_device_resume() should not complain about SCSI devices that
>>>> have been skipped. Hence this patch. This patch avoids that the
>>>> following warning appears>
>>>> during resume:
>>> Am I on CC cause one of those warnings appeared in bug reports from
>>> me from quite some time ago?
> […]
>> That's correct. I hope that you don't mind that I cc'ed you?
> 
> No, I don't mind.
> 
> Would you like me to apply the patch in order to test it? As it is just
> about suppressing a kernel warning and not changing any major
> functionality, I wondered whether you like me to do with this or whether
> the CC is more JFYI.

Hi Martin,

I had cc'd you in case you would have hit the same warning. If you have 
not yet encountered this warning it's probably not that important that 
you test this patch.

Best regards,

Bart.
