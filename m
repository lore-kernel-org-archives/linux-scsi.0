From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] block: fix blk_rq_map_kern bio direction flag
Date: Mon, 13 Sep 2010 21:30:53 +0200
Message-ID: <4C8E7BED.3080003@fusionio.com>
References: <1284404907-14599-1-git-send-email-bhalevy@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1284404907-14599-1-git-send-email-bhalevy@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

On 2010-09-13 21:08, Benny Halevy wrote:
> This bug was introduced in 7b6d91daee5cac6402186ff224c3af39d79f4a0e
> "block: unify flags for struct bio and struct request"

Thanks, that's pretty nasty. I'll expedite this.

-- 
Jens Axboe
