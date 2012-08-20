From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [patch 1/2]block: handle merged discard request
Date: Mon, 20 Aug 2012 10:12:29 -0400
Message-ID: <20120820141229.GC28570@redhat.com>
References: <4F69C62C.7020604@kernel.org>
 <yq18vitwejt.fsf@sermon.lab.mkp.net>
 <CANejiEX26=jqijgTwb0iLMw7WC7byF1o+whwp3K5CcY5_a8o8w@mail.gmail.com>
 <yq1zkb9uz1t.fsf@sermon.lab.mkp.net>
 <20120620085724.GA26295@infradead.org>
 <yq1fw9o3t5b.fsf@sermon.lab.mkp.net>
 <CAMM=eLcBMrOfhJZU2GsSnMXkmWZMemJcvTM6WPLiiXkysXHYiQ@mail.gmail.com>
 <yq1wr0weu9q.fsf@sermon.lab.mkp.net>
 <20120820135739.GB28570@redhat.com>
 <20120820135854.GA19254@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120820135854.GA19254@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Shaohua Li <shli@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, linux-kernel@vger.kernel.org, neilb@suse.de, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 20 2012 at  9:58am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Aug 20, 2012 at 09:57:39AM -0400, Mike Snitzer wrote:
> > But I haven't put my finger on _why_ a discard bio has bio->bi_io_vec
> > (but given my use of DM, bio comes from bio_alloc_bioset, and DM passes
> > original bio->bi_max_vecs for nr_iovecs).
> 
> TRIM has a payload and we cheay by preallocation a data page for it.

Thought we pushed that down?  Hence sd_setup_discard_cmnd's
alloc_page + blk_add_request_payload hack.
