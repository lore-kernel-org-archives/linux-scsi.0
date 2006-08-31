From: "Ed Lin" <ed.lin@promise.com>
Subject: Re: [PATCH] block: add support for shared tag maps
Date: Thu, 31 Aug 2006 16:55:35 +0800
Message-ID: <NONAMEBU6CuyzC0bHwr00000ed4@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:20638 "EHLO
	nonameb.ptu.promise.com") by vger.kernel.org with ESMTP
	id S1750724AbWHaIzQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 04:55:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <axboe@suse.de>


======= On 2006-08-30 21:44:18, James Bottomley wrote:
>+
>+/**
>+ * blk_free_tags - release a given set of tag maintenance info
>+ *
>+ * @bqt:	the tag map to free
>+ *
>+ * For externally managed @bqt@ frees the map.  Callers of this
>+ * function must guarantee to have released all the queues that
>+ * might have been using this tag map.
>+ */
>+void blk_free_tags(struct blk_queue_tag *bqt)
>+{
>+	if (unlikely(!__blk_free_tags(bqt)))
>+		BUG();
>+}
>+

EXPORT_SYMBOL(blk_free_tags) ?
Also, add new function definitions in blkdev.h?

