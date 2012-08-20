From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 1/2]block: handle merged discard request
Date: Mon, 20 Aug 2012 10:15:13 -0400
Message-ID: <20120820141513.GA3418@infradead.org>
References: <yq18vitwejt.fsf@sermon.lab.mkp.net>
 <CANejiEX26=jqijgTwb0iLMw7WC7byF1o+whwp3K5CcY5_a8o8w@mail.gmail.com>
 <yq1zkb9uz1t.fsf@sermon.lab.mkp.net>
 <20120620085724.GA26295@infradead.org>
 <yq1fw9o3t5b.fsf@sermon.lab.mkp.net>
 <CAMM=eLcBMrOfhJZU2GsSnMXkmWZMemJcvTM6WPLiiXkysXHYiQ@mail.gmail.com>
 <yq1wr0weu9q.fsf@sermon.lab.mkp.net>
 <20120820135739.GB28570@redhat.com>
 <20120820135854.GA19254@infradead.org>
 <20120820141229.GC28570@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120820141229.GC28570@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Shaohua Li <shli@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, linux-kernel@vger.kernel.org, neilb@suse.de, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 20, 2012 at 10:12:29AM -0400, Mike Snitzer wrote:
> Thought we pushed that down?  Hence sd_setup_discard_cmnd's
> alloc_page + blk_add_request_payload hack.

Yeah, but we still need the bio_vec from early on, as it's allocated as
part of the bio.
