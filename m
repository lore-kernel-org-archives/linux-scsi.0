From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2 of 9] block: Export I/O topology for block devices and
 	partitions
Date: Fri, 24 Apr 2009 08:54:37 -0400
Message-ID: <49F1B68D.3010304@garzik.org>
References: <patchbomb.1240551141@sermon.lab.mkp.net> <72f4e15760670febdb40.1240551143@sermon.lab.mkp.net> <ac3eb2510904240514y660973abj7621864e11e514f2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510904240514y660973abj7621864e11e514f2@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, matthew@wil.cx, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Kay Sievers wrote:
> On Fri, Apr 24, 2009 at 07:32, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
>> +What:          /sys/block/<disk>/alignment
>> +What:          /sys/block/<disk>/<partition>/alignment
>> +What:          /sys/block/<disk>/queue/minimum_io_size
>> +What:          /sys/block/<disk>/queue/optimal_io_size
> 
> Wouldn't it be good to include "sector", like the queue files do? The
> alignment of a partition could mean many things.
>   /sys/block/<disk>/sector_alignment
>   /sys/block/<disk>/<partition>/sector_alignment
> 
> And prefixing the io values might be easier to read when they show up
> in a group?
>   /sys/block/<disk>/queue/io_minimum_size
>   /sys/block/<disk>/queue/io_optimal_size
>   /sys/block/<disk>/queue/io_...

Why do we need all this syscall overhead just to read individual data items?

Isn't it dumb to require 30 userland syscalls simply to input a 
10-member data structure?

netlink looks more and more attractive for anything non-trivial.

	Jeff



