From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 01/14] blk-mq: kill q->mq_map
Date: Mon, 29 Oct 2018 10:51:01 -0600
Message-ID: <f0a96403-df1a-6151-166c-a4b82f678234@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
 <20181029163738.10172-2-axboe@kernel.dk> <1540831588.196084.54.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540831588.196084.54.camel@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/29/18 10:46 AM, Bart Van Assche wrote:
> On Mon, 2018-10-29 at 10:37 -0600, Jens Axboe wrote:
>> It's just a pointer to set->mq_map, use that instead.
> 
> Please clarify in the patch description that the q->tag_set assignment
> has been moved because this patch makes it necessary to have that pointer
> available earlier such that it is clear that that move is intentional.
> Anyway:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Good point, I'll improve the verbiage in the commit message. Thanks.

-- 
Jens Axboe
