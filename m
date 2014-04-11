From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH 3/4] blk-mq: move request structures into struct blk_mq_tags
Date: Thu, 10 Apr 2014 20:42:27 -0600
Message-ID: <53475693.7050609@fb.com>
References: <1396277175-21382-1-git-send-email-hch@lst.de> <1396277175-21382-4-git-send-email-hch@lst.de> <53457404.5070800@fb.com> <20140410100144.GB20342@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140410100144.GB20342@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Matias Bjorling <m@bjorling.me>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2014-04-10 04:01, Christoph Hellwig wrote:
> On Wed, Apr 09, 2014 at 10:23:32AM -0600, Jens Axboe wrote:
>> This should go into block/blk-mq-tag.h.
>
> Ok.
>
>> We might as well leave this, the mtip32xx conversion ends up using it. So
>> if we pull it now, it'll just be reintroduced shortly.
>
> It's back in the latest revision of the patch, just taking a
> struct blk_mq_tag pointer now so that it can be used by SCSI as well.
>
> I've also changed an opencode variant of it to use the helper.

Great. Will you send out an updated patchset?

-- 
Jens Axboe
