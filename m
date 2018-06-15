From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2] block: fix bsg_unregister and bsg_open race
Date: Fri, 15 Jun 2018 11:27:41 +0200
Message-ID: <20180615092741.GA21138@lst.de>
References: <20180613221417.GA22778@xldev-tmpl.dev.purestorage.com> <20180614083806.GA18966@lst.de> <20180614234733.GA38460@xldev-tmpl.dev.purestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180614234733.GA38460@xldev-tmpl.dev.purestorage.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Anatoliy Glagolev <glagolig@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 14, 2018 at 05:47:34PM -0600, Anatoliy Glagolev wrote:
> Thanks, Christoph. Good catch releasing the mutex on failure path.
> V2 patch with your suggestions applied.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Now just re-add the changelog and resend it in a new thread.
