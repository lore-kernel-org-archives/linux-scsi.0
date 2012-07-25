From: Sen Wang <kelvin.xupt@gmail.com>
Subject: Re: [PATCH] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
Date: Wed, 25 Jul 2012 19:46:18 +0800
Message-ID: <CAKviJvW5w_9_wMazs3HQigosuk+W-iQipb_0pZxr0-bu3xhGbg@mail.gmail.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com>
	<ccef753fa6fd0ce145611de514e75018@sf-mail.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ccef753fa6fd0ce145611de514e75018@sf-mail.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, jbottomley@parallels.com, pbonzini@redhat.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

2012/7/25 Rolf Eike Beer <eike-kernel@sf-tec.de>:
> Am 25.07.2012 10:29, schrieb Wang Sen:
>
>> When using the commands below to write some data to a virtio-scsi LUN of
>> the
>> QEMU guest(32-bit) with 1G physical memory(qemu -m 1024), the qemu
>> will crash.
>>
>>         # sudo mkfs.ext4 /dev/sdb  (/dev/sdb is the virtio-scsi LUN.)
>>         # sudo mount /dev/sdb /mnt
>>         # dd if=/dev/zero of=/mnt/file bs=1M count=1024
>>
>> In current implementation, sg_set_buf is called to add buffers to sg
>> list which
>> is put into the virtqueue eventually.
>
>
> The next sentence is somehow broken:
>
>
>> But there are some HighMem pages in
>> table->sgl can not get virtual address by sg_virt.
>
>
> Maybe something like "But _if_ there are ... _you_ can not get ..."?

Thanks, I'll pay attention in next post.

>
> Eike
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
------------------------------------------
Wang Sen
Addr: XUPT,Xi'an,Shaanxi,China
Email: kelvin.xupt@gmail.com
------------------------------------------
