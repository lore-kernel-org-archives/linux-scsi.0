From: Luben Tuikov <luben@splentec.com>
Subject: Re: I/O Request [Elevator; Clustering; Scatter-Gather]
Date: Tue, 04 Mar 2003 13:04:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E64EAB4.5020502@splentec.com>
References: <OFDE36CE13.9373E086-ON87256CDF.0060BDDC-88256CDF.0061A289@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <OFDE36CE13.9373E086-ON87256CDF.0060BDDC-88256CDF.0061A289@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Jens Axboe <axboe@suse.de>, David Anderson <david-anderson2003@mail.com>, linux-scsi@vger.kernel.org, Daniel Phillips <phillips@arcor.de>

Bryan Henderson wrote:
> 
> 
> 
>>>Scatter-gather may cluster sg entries that are
>>>
>>>>contiguous in memory.
> 
> Please explain this function.
>

But, he did explain it.

Basically if you have two or more sg entries (vaguely
a buffer address and buffer length) *and* they are contiguous
in memory (tricky), i.e. (100,100), (200,100), (300,100),
then a smart choice would be to make just a single sg
entry (100,300). (This was just an example for illustratory
puposes.)

For the other concepts, the book
"Operating System Concepts", Silberschatz & Galvin,
Addison-Wesley, 1998, ISBN 0-201-59113-8, commonly
referred to as ``the dinosaur book'' (because of the
dinosaurs depicted on the cover) is a good start.


> The only "scatter gather" I've heard of is the concept of a single I/O
> having a discontiguous buffer.  If it's a write, the system gathers bytes
> from multiple separate buffers into a single write.  If it's a read, the
> system scatters the bytes from a single read into multiple separate
> buffers.
> 
> The readv() and writev() system calls are examples of something that
> implements a scatter/gather function.  (But not the scatter/gather function
> we're talking about here).
> 
> When you cluster disk I/O by combining separate requests that happen to be
> to adjacent disk locations, you must have a scatter/gather function
> somewhere (e.g. the disk controller or DMA controller) to make it work,
> because those requests probably don't have contiguous buffers.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Luben


