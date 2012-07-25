From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
Date: Wed, 25 Jul 2012 12:04:33 +0200
Message-ID: <ccef753fa6fd0ce145611de514e75018@sf-mail.de>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wang Sen <senwang@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, pbonzini@redhat.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Am 25.07.2012 10:29, schrieb Wang Sen:
> When using the commands below to write some data to a virtio-scsi LUN 
> of the
> QEMU guest(32-bit) with 1G physical memory(qemu -m 1024), the qemu
> will crash.
>
> 	# sudo mkfs.ext4 /dev/sdb  (/dev/sdb is the virtio-scsi LUN.)
> 	# sudo mount /dev/sdb /mnt
> 	# dd if=/dev/zero of=/mnt/file bs=1M count=1024
>
> In current implementation, sg_set_buf is called to add buffers to sg
> list which
> is put into the virtqueue eventually.

The next sentence is somehow broken:

> But there are some HighMem pages in
> table->sgl can not get virtual address by sg_virt.

Maybe something like "But _if_ there are ... _you_ can not get ..."?

Eike
