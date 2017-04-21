From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 3/4] nfs: remove the objlayout driver
Date: Fri, 21 Apr 2017 03:50:38 -0700
Message-ID: <20170421105038.GA28396@infradead.org>
References: <20170412160109.10598-1-hch@lst.de>
 <20170412160109.10598-4-hch@lst.de>
 <CAD3Xx4+79ryvNDtB4F1v-9TxQe8sTxYKeysCGqWuUYG8Ca=Yxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAD3Xx4+79ryvNDtB4F1v-9TxQe8sTxYKeysCGqWuUYG8Ca=Yxg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Valentin Rothberg <valentinrothberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, ooo-rh7Tgz9RNieUD9Wbbkgo/g@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, osd-dev-yNzVSZO3znNg9hUCZPvPmw@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 21, 2017 at 09:27:11AM +0200, Valentin Rothberg wrote:
> Hi Christoph,
> 
> I just came across this patch in linux-next commit 6d22323b2e9f.
> scripts/checkkconfigsymbols.py reports that there is a leftover
> reference on PNFS_OBJLAYOUT in fs/exofs/Kconfig.ore line 10 (depends
> on EXOFS_FS || PNFS_OBJLAYOUT). I assume that this reference can
> safely be removed now? If you want to I can send a trivial patch
> removing it.

Yes, please do.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
