From: Christoph Hellwig <hch@lst.de>
Subject: Re: [REGRESSION v4.10-rc1] blkdev_issue_zeroout() returns
        -EREMOTEIO on the first call for SCSI device that doesn't support
        WRITE SAME
Date: Sat, 4 Feb 2017 09:48:07 +0100
Message-ID: <20170204084807.GA17559@lst.de>
References: <cc14c28a-0f0a-640a-b576-cdfbaee75dc5@ce.jp.nec.com> <d360a634-2c95-2de5-8647-4e740e92e10a@kernel.dk> <20170203161239.GA3880@lst.de> <1e819f0d-ecdc-e54a-bd3d-17de2f71c8a7@kernel.dk> <yq1wpd6vqpm.fsf@oracle.com> <34e7f917-8fff-d8f9-c498-3431a27113ca@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <34e7f917-8fff-d8f9-c498-3431a27113ca@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Junichi Nomura <j-nomura@ce.jp.nec.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Chaitanya Kulkarni <chaitanya.kulkarni@hgst.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 03, 2017 at 08:17:10PM -0700, Jens Axboe wrote:
> We're at (almost) -rc7 time, we have to do more than hand wave about
> this. What's the plan for 4.10 final?

I'll send your a fix to revert the async write same changes for now,
as suggested in the last mail from me.
