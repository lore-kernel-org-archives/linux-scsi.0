From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/15] block/bsg: move queue creation into
        bsg_setup_queue
Date: Wed, 11 Jan 2017 10:01:12 +0100
Message-ID: <20170111090112.GA7239@lst.de>
References: <1484060780-15592-1-git-send-email-hch@lst.de> <1484060780-15592-15-git-send-email-hch@lst.de> <20170111084218.GB6286@linux-x5ow.site> <20170111084512.GA6937@lst.de> <8810984d-9929-8937-e82c-94639fd0b8ea@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8810984d-9929-8937-e82c-94639fd0b8ea@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 11, 2017 at 09:59:17AM +0100, Hannes Reinecke wrote:
> I'd advocate to discuss this at LSF.
> Now that Mike moved the bio-based mpath stuff back in things got even
> more complex.

Yeah.  If we'd _only_ have bio based support it would simplify things
a lot, but as a third parallel path it's not exactly making things easier.

> I'll be posting a patchset for reimplementing multipath as a stand-alone
> driver shortly; that'll give us a good starting point on how we want
> multipath to evolve.
> 
> Who knows; we might even manage to move multipath out of device-mapper
> altogether.
> That would make Mike very happy, and I wouldn't mind, either :-)

Heh.  I'm curious how you want to do that while keeping existing setups
working, though.
