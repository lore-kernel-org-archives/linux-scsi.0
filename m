From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/11] block: rename barrier/ordered to flush
Date: Tue, 17 Aug 2010 15:26:46 +0200
Message-ID: <20100817132646.GA3577@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <1281616891-5691-9-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1281616891-5691-9-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

> -#define blk_queue_flushing(q)	((q)->ordseq)
> +#define blk_queue_flushing(q)	((q)->flush_seq)

Btw, I think this one should just go away.  It's only used by
ide in an attempt to make ordered sequences atomic, which isn't
needed for the new design.
