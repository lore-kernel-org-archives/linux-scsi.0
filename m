From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
Date: Tue, 16 Sep 2014 14:37:39 -0700
Message-ID: <20140916213739.GA19111@infradead.org>
References: <20140708134003.GA7790@infradead.org>
 <20140801122042.GA10771@infradead.org>
 <20140915225818.GA11869@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140915225818.GA11869@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 15, 2014 at 03:58:18PM -0700, Christoph Hellwig wrote:
> I've pushed two updates to the core-for-3.17 branch of
> 
>     git://git.infradead.org/users/hch/scsi-queue.git
> 
> which should go to Linus before the next rc.
> 
> One is a regression fix for drivers using block layer tagging when
> not using blk-mq introduced in the blk-mq series, and the other
> fixes a potential buffer overrun in the iscsi initiator.
> 
> Updates of the for-3.18 trees will follow soon.

core-for-3.17 has grown another fix from Daniel for bidi support.

core-for-3.18 has got the autopm fix to balance the calls and thus
	handle LUNs without attached ULD

drivers-for-3.18 has the megaraid, mpt and arcmsr updates as well as a
	bnx fix
