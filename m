From: Christoph Hellwig <hch@infradead.org>
Subject: Re: device support in hpsa, was: Re: OOPS from cciss_ioctl in
 4.12+git
Date: Fri, 7 Jul 2017 11:08:57 -0700
Message-ID: <20170707180857.GA19790@infradead.org>
References: <alpine.LRH.2.20.1707051555130.20086@math.ut.ee>
 <20170705225134.GA31786@infradead.org>
 <alpine.LRH.2.20.1707061236010.6514@math.ut.ee>
 <20170707150042.GA15445@infradead.org>
 <799cf0d6-658d-4124-1ba0-3962671e3f1e@kernel.dk>
 <1bc9895b-bfcb-9ff5-c046-277b0d67a94e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1bc9895b-bfcb-9ff5-c046-277b0d67a94e@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Meelis Roos <mroos@linux.ee>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, Don Brace <don.brace@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 07, 2017 at 11:42:38AM -0400, Laurence Oberman wrote:
> What happens when  hpsa_allow_any=1 with the Smart Array 64xx
> It should probe.

But only if it has a HP vendor ID as far as I can tell.  We'd
still need to add the compaq ids so that these controllers get
probed.  But maybe it's time to add them and flip the hpsa_allow_any
default (maybe conditionally on a config option?) and mark cciss
deprecated.
