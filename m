From: Daniel Phillips <phillips@arcor.de>
Subject: Re: I/O Request [Elevator; Clustering; Scatter-Gather]
Date: Tue, 4 Mar 2003 22:10:55 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030304141948.264C63BF9D@mx01.nexgo.de>
References: <20030304133201.18619.qmail@mail.com> <20030304135000.GA29990@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20030304135000.GA29990@suse.de>
To: Jens Axboe <axboe@suse.de>, David Anderson <david-anderson2003@mail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 04 March 2003 14:50, Jens Axboe wrote:
> > Do Clustering of request and scatter-gather mean the same ?? Confused
> > to the core... Kindly help me ...
>
> No, the elevator clustering refers to clustering request that are
> contigious on disk. Scatter-gather may cluster sg entries that are
> contigious in memory.

Hi Jens,

I think you meant to write *non*contiguous in memory (but contiguous on the 
device).

Regards,

Daniel
