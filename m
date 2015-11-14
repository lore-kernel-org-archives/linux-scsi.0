From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/9] move blk_iopoll to limit and make it generally
	available
Date: Sat, 14 Nov 2015 08:02:48 +0100
Message-ID: <20151114070248.GB27738@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-2-git-send-email-hch@lst.de> <564637BC.7080604@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <564637BC.7080604@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, sagig@dev.mellanox.co.il, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 13, 2015 at 11:19:24AM -0800, Bart Van Assche wrote:
> On 11/13/2015 05:46 AM, Christoph Hellwig wrote:
>> The new name is irq_poll as iopoll is already taken.  Better suggestions
>> welcome.
>
> Hello Christoph,
>
> Would it be possible to provide more background information about this ? 
> Which other kernel subsystem is using the name iopoll ?

Take a look at include/linux/iopoll.h  - I can't reaplly make much sense
of it to be honest, but it's used in a quite a few places.
