From: Christoph Hellwig <hch@lst.de>
Subject: Re: sense handling improvements
Date: Thu, 23 Feb 2017 15:31:35 +0100
Message-ID: <20170223143135.GA2449@lst.de>
References: <20170214191600.17480-1-hch@lst.de> <yq18tp6by2n.fsf@oracle.com> <20170222071915.GA18084@lst.de> <yq1shn57mqn.fsf@oracle.com> <20170223094948.GA29551@lst.de> <yq1efyp6kxn.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1efyp6kxn.fsf@oracle.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 23, 2017 at 09:28:20AM -0500, Martin K. Petersen wrote:
> >>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:
> 
> Christoph,
> 
> >> I applied 1-4 to 4.11/scsi-fixes. Both 5 and 6 had problems so please
> >> fix those up.
> 
> Christoph> What kind of problem?  I didn't see anything on the list.
> 
> They didn't apply. I tried to fix them up by hand. 5 was easy but 6
> caused a flurry of failures that I ran out of time to look into.
> 
> So please resubmit 5 and 6 against 4.11/scsi-fixes.

Ok, I'll take a look.  They apply fine to mkp/for-next so there must
be some other patches changing the code.
