From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: two more fixes for block/for-linus
Date: Mon, 22 Sep 2014 14:40:15 -0400
Message-ID: <54206D0F.1010506@interlog.com>
References: <1411394371-16254-1-git-send-email-hch@lst.de> <54202CF9.7050303@kernel.dk>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54202CF9.7050303@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Elliott, Robert (Server Storage)" <elliott@hp.com>
List-Id: linux-scsi@vger.kernel.org

On 14-09-22 10:06 AM, Jens Axboe wrote:
> On 2014-09-22 07:59, Christoph Hellwig wrote:
>> Fix two regressions with the timer/blk_mq_start_request changes found
>> when using scsi-mq on an ATA device.
>>
>> Note that given how late we are in the cycle I wonder if we really should
>> push the changes in block/for-linus to Linus in this cycle.  The race
>> part of the timer fixes is extremly narrow, and the reserved request
>> part of it requires an out of tree driver update to trigger it, so it
>> doesn't sound super criticial.
>
> I was planning on pushing it out today, I've run a lot of testing on it
> internally last week. Ho hum, let me think about it...

With these patches applied (actually a resync an hour
ago with the for-linus tree which includes them), the
freeze-during-boot-up problem that I have been seeing
with an old SATA boot disk (perhaps 1.5 Gbps) for
the last two weeks, has gone away.

That SATA disk is connected to the motherboard (Gigabyte
Z97M-D3H/Z97M-D3H, BIOS F5 05/30/2014) and has a standard
AHCI interface as far as I can tell. dmesg confirms that.


Please add "Tested-by: Douglas Gilbert <dgilbert@interlog.com>"
to Christoph's "two more fixes for block/for-linus" series.

Doug Gilbert
