From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCHv2] block: fix bsg_unregister and bsg_open race
Date: Fri, 15 Jun 2018 08:16:33 -0600
Message-ID: <da65970e-cda6-6170-eaa2-1fe2a1b59322@kernel.dk>
References: <20180613221417.GA22778@xldev-tmpl.dev.purestorage.com>
 <20180614083806.GA18966@lst.de>
 <20180614234733.GA38460@xldev-tmpl.dev.purestorage.com>
 <20180615092741.GA21138@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180615092741.GA21138@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Anatoliy Glagolev <glagolig@gmail.com>
Cc: linux-block@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/15/18 3:27 AM, Christoph Hellwig wrote:
> On Thu, Jun 14, 2018 at 05:47:34PM -0600, Anatoliy Glagolev wrote:
>> Thanks, Christoph. Good catch releasing the mutex on failure path.
>> V2 patch with your suggestions applied.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Now just re-add the changelog and resend it in a new thread.

The original one was mixed up, too. Anatoliy, I fixed it up for
you. But for future patches, please follow the usual patch
format where the commit message is actually in the patch.

-- 
Jens Axboe
