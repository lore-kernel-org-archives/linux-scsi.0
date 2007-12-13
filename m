From: Mark Lord <lkml@rtr.ca>
Subject: Re: QUEUE_FLAG_CLUSTER: not working in 2.6.24 ?
Date: Thu, 13 Dec 2007 14:03:59 -0500
Message-ID: <4761821F.3050602@rtr.ca>
References: <47617B92.6020908@rtr.ca> <47617C07.3020501@rtr.ca> <47617E72.6080504@rtr.ca> <20071213185326.GQ26334@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20071213185326.GQ26334@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jens Axboe <axboe@kernel.dk>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Dec 13, 2007 at 01:48:18PM -0500, Mark Lord wrote:
>> Problem confirmed.  2.6.23.8 regularly generates segments up to 64KB for 
>> libata,
>> but 2.6.24 uses only 4KB segments and a *few* 8KB segments.
> 
> Just a suspicion ... could this be slab vs slub?  ie check your configs
> are the same / similar between the two kernels.
..

Mmmm.. a good thought, that one.
But I just rechecked, and both have CONFIG_SLAB=y

My guess is that something got changed around when Jens
reworked the block layer for 2.6.24.
I'm going to dig around in there now.

