From: Jens Axboe <axboe@kernel.dk>
Subject: Re: remove the cmd_type field from struct request
Date: Tue, 31 Jan 2017 13:07:01 -0800
Message-ID: <13b5993e-5b1b-696c-cdea-50c1ffade5ec@kernel.dk>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1485878251-6107-1-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/31/2017 07:57 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series gets rid of the cmd_type field in struct request and
> instead folds it into the REQ_OP* space.  This reduces the size of
> struct request, and leads to a single op namespace that drivers
> can easily switch on.  Except for the legacy ide driver which has
> a mess of different request types [1] this also nicely cleans up the
> code.
> 
> Note that the patches are on top of the
> 
>     "make SCSI passthrough support optional"
> 
> series I sent out on Saturday.  To make life easier I also have a git
> tree available here:
> 
> 	git://git.infradead.org/users/hch/block.git cmd_type
> 
> 	http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/cmd_type

Looks good to me, applied for 4.11.

-- 
Jens Axboe

