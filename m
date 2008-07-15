From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in blk_recalc_rq_segments
 about VMERGE
Date: Tue, 15 Jul 2008 11:46:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0807151143050.29803@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807150924250.21598@devserv.devel.redhat.com>
 <20080715231956A.fujita.tomonori@lab.ntt.co.jp>
 <Pine.LNX.4.64.0807151033040.25390@devserv.devel.redhat.com>
 <20080716003047P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <20080716003047P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-parisc-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davem@davemloft.net, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>> Even if we fix it now, the question is: how long it will stay fixed? Until
>> someone makes another change to struct device that restricts boundaries on
>> some wacky hardware.
>
> I'm not sure how the boundary restriction of a device can break
> the VMERGE accounting.

Because block layer code doesn't know anything about the device, pci 
access restrictions and so on.

Someone already broken DaveM's Sparc64 merging by adding boundaries (it 
was broken even before, but these boundary checks made it worse).

Mikulas
