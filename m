From: Christoph Hellwig <hch@lst.de>
Subject: Re: split scsi passthrough fields out of struct request
Date: Mon, 23 Jan 2017 16:46:46 +0100
Message-ID: <20170123154646.GA400@lst.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de> <ab371cbe-9abc-877e-b529-a7a3c39ff229@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ab371cbe-9abc-877e-b529-a7a3c39ff229@fb.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 23, 2017 at 08:39:44AM -0700, Jens Axboe wrote:
> I'd like to get this in sooner rather than later, so I'll spend some
> time reviewing and testing it start this week. I'm assuming you are
> targeting 4.11 with this change, right?

Yes.
