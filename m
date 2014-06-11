From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] notify block layer when using temporary change to
 cache_type
Date: Wed, 11 Jun 2014 05:07:13 -0700
Message-ID: <20140611120713.GB16616@infradead.org>
References: <1401788250-8457-1-git-send-email-vaughan.cao@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1401788250-8457-1-git-send-email-vaughan.cao@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: JBottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 03, 2014 at 05:37:30PM +0800, Vaughan Cao wrote:
> This is a fix for commit:
>   39c60a0948cc06139e2fbfe084f83cb7e7deae3b sd: fix array cache flushing bug causing performance problems
> We must notify the block layer via q->flush_flags after temporary change the cache_type to write through.
> If not, SYNCHRONIZE CACHE command will still be generated.
> This patch factors out a helper that can be called from sd_revalidate_disk and cache_type_store.
> 
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
