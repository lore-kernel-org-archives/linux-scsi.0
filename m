From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 14/25] nbd: don't use req->errors
Date: Thu, 6 Apr 2017 17:11:00 -0400
Message-ID: <5819A1CC-BB9E-4B28-B41A-B4F6EBCE5D0C@toxicpanda.com>
References: <20170406153944.10058-1-hch@lst.de>
 <20170406153944.10058-15-hch@lst.de>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170406153944.10058-15-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?utf-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org


> On Apr 6, 2017, at 11:39 AM, Christoph Hellwig <hch@lst.de> wrote:
> 
> Add a nbd-specific field instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This is fine with me, you can add,

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
