From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: Re: [PATCH] scsi_lib: increase {host|target|device}_busy count after
 dispatch cmd
Date: Fri, 2 Mar 2018 12:56:26 +0800
Message-ID: <CADAEsF8OySXKpqBmN-Vi+8md=RpHAyUghO99UnrwJRdD72yWCQ@mail.gmail.com>
References: <1496655478-4039-1-git-send-email-opensource.ganesh@gmail.com> <1519945861.2675.9.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519945861.2675.9.camel@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi, Bart:

2018-03-02 7:11 GMT+08:00 Bart Van Assche <Bart.VanAssche@wdc.com>:
> On Mon, 2017-06-05 at 17:37 +0800, Ganesh Mahendran wrote:
>> In android system, when there are lots of threads running. Thread A
>> holding *host_busy* count is easily to be preempted, and if at the
>> same time, thread B set *host_blocked*, then all other threads will
>> be io blocked.
>
> Hello Ganesh,
>
> Have you considered to insert preempt_disable() and preempt_enable() calls
> where necessary to achieve the same effect? I think that would result in a
> much less intrusive patch.

Yes, preempt_disable()preempt_enable will also achieve the same effect.
But I just think preempt_disable()preempt_enable may be a little heavy for
this problem which can be fixed by increaseing {host|target|device}_busy count
after dispatch cmd.

Thanks.

>
> Thanks,
>
> Bart.
>
>
