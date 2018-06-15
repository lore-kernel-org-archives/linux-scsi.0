From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] block: export __blk_complete_request
Date: Fri, 15 Jun 2018 13:58:19 +0200
Message-ID: <20180615115819.GA25694@lst.de>
References: <1529027847-29085-1-git-send-email-jianchao.w.wang@oracle.com> <CACVXFVMe4zSvfXfuSn0NFayeQqbmDwBBy1kcso=5iznT6EfpSA@mail.gmail.com> <3dd3f82a-5b68-f039-3a8a-7c5fe4e24c3e@oracle.com> <e5344293-b0b7-d2e0-f2e7-c0700efdfbe4@oracle.com> <CACVXFVMRCM6AvNJjAESbwOeJ_P5AZ+1C-7RfhE9L4u0T=_5h4Q@mail.gmail.com> <3970fdc7-52d9-d05b-4118-059d48bf4f2d@oracle.com> <CACVXFVMPAdFbX3x-KUjHCQhb_rT6p9ROYHg63aUtEqdbitEaKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVMPAdFbX3x-KUjHCQhb_rT6p9ROYHg63aUtEqdbitEaKQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: "jianchao.wang" <jianchao.w.wang@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block <linux-block@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 15, 2018 at 11:20:40AM +0800, Ming Lei wrote:
> > but blk_mq_check_expired doesn't do that.
> > do I miss anything ?
> 
> Right, that is the difference between blk-mq and legacy now, then if scsi-mq
> drivers can work well, they should work well with the following change in the
> non-mq mode:

We'll still need referene counting against reuse and/or premature
freeing of requests.
