From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/23] dm-kcopyd: switch to use REQ_OP_WRITE_ZEROES
Date: Thu, 23 Mar 2017 15:56:51 +0100
Message-ID: <20170323145651.GA31771@lst.de>
References: <20170323143341.31549-1-hch@lst.de> <20170323143341.31549-7-hch@lst.de> <20170323145522.GB17127@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170323145522.GB17127@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 23, 2017 at 10:55:22AM -0400, Mike Snitzer wrote:
> See commit 70d6c400a ("dm kcopyd: add WRITE SAME support to dm_kcopyd_zero")
> drivers/md/dm-io.c:do_region() adjusts the WRITE SAME payload to be a
> single page.
> 
> So you'd want to tweak dm-io.c accordingly for WRITE ZEROES (presummably
> no payload?)

Yeah, I'll look into it.  Any good test case for verifying this code
while I've got your attention?
