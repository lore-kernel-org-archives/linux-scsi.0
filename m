From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 5/8] scsi: introduce force_blk_mq
Date: Wed, 7 Feb 2018 08:46:59 +0800
Message-ID: <20180207004658.GC13470@ming.t460p>
References: <20180205152035.15016-1-ming.lei@redhat.com>
 <20180205152035.15016-6-ming.lei@redhat.com>
 <20180206202043.GB16027@vader.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180206202043.GB16027@vader.DHCP.thefacebook.com>
Sender: linux-block-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 06, 2018 at 12:20:43PM -0800, Omar Sandoval wrote:
> On Mon, Feb 05, 2018 at 11:20:32PM +0800, Ming Lei wrote:

...
> >  	shost->use_blk_mq = scsi_use_blk_mq;
> 
> Not sure if this is a patch formatting issue, but this old line wasn't
> deleted.

Good catch, the old line need to be removed.

Thanks,
Ming
