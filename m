From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: block: Always check queue limits for cloned requests
Date: Mon, 30 Nov 2015 08:12:51 +0100
Message-ID: <20151130071251.GA315@x4>
References: <1448524017-130967-1-git-send-email-hare@suse.de>
 <20151126131104.GA24297@redhat.com>
 <20151129114956.GA321@x4>
 <565B1D2A.5010603@suse.de>
 <20151129161532.GA302@x4>
 <20151129164947.GA15021@redhat.com>
 <20151129170506.GB302@x4>
 <20151130141141.6ce3fadb@tom-T450>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151130141141.6ce3fadb@tom-T450>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ewan Milne <emilne@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 2015.11.30 at 14:11 +0800, Ming Lei wrote:
> On Sun, 29 Nov 2015 18:05:06 +0100
> Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> > 
> > No, I'm not using DM multipath. 
> 
> 
> OK, I guess it is still one block merge issue, care to test the
> following patch?
> 
> The patch can address one issue when bio->bi_seg_front_size
> is set as too small mistakenly, then fewer physical segment may
> be figured out.

Many thanks. Your patch fixes the issue for me.

-- 
Markus
