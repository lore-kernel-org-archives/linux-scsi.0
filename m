From: Jens Axboe <axboe@suse.de>
Subject: Re: I/O Request [Elevator; Clustering; Scatter-Gather]
Date: Tue, 4 Mar 2003 15:20:41 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030304142041.GA660@suse.de>
References: <20030304133201.18619.qmail@mail.com> <20030304135000.GA29990@suse.de> <20030304141948.264C63BF9D@mx01.nexgo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030304141948.264C63BF9D@mx01.nexgo.de>
List-Id: linux-scsi@vger.kernel.org
To: Daniel Phillips <phillips@arcor.de>
Cc: David Anderson <david-anderson2003@mail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Mar 04 2003, Daniel Phillips wrote:
> On Tuesday 04 March 2003 14:50, Jens Axboe wrote:
> > > Do Clustering of request and scatter-gather mean the same ?? Confused
> > > to the core... Kindly help me ...
> >
> > No, the elevator clustering refers to clustering request that are
> > contigious on disk. Scatter-gather may cluster sg entries that are
> > contigious in memory.
> 
> Hi Jens,
> 
> I think you meant to write *non*contiguous in memory (but contiguous on the 
> device).

No I didn't. Well actually both may happen, depending on your hardware.
What I wrote covers basic x86 hardware.

-- 
Jens Axboe

