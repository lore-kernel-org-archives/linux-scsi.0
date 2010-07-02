From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] scsi: remove unused free discard page in sd_done
Date: Fri, 2 Jul 2010 12:52:56 +0200
Message-ID: <20100702105256.GE26318@lst.de>
References: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1277981359-10717-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1277981359-10717-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: axboe@kernel.dk, snitzer@redhat.com, hch@lst.de, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 01, 2010 at 07:49:19PM +0900, FUJITA Tomonori wrote:
> - sd_done isn't called for pc request so we never call the code.
> - we use sd_unprep to free discard page now.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>
