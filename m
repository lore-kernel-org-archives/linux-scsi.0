From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/60] target: avoid to access .bi_vcnt directly
Date: Mon, 31 Oct 2016 08:26:42 -0700
Message-ID: <20161031152642.GC30919@infradead.org>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
 <1477728600-12938-6-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477728600-12938-6-git-send-email-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 29, 2016 at 04:08:04PM +0800, Ming Lei wrote:
> When the bio is full, bio_add_pc_page() will return zero,
> so use this way to handle full bio.
> 
> Also replace access to .bi_vcnt for pr_debug() with bio_segments().
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
