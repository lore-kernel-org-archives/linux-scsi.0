From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH][SCSI] scsi-mq: fix requests that use a separate CDB buffer
Date: Mon, 25 Aug 2014 10:04:51 -0400
Message-ID: <53FB4283.4020704@cybernetics.com>
References: <53F79FC3.6040907@cybernetics.com> <53F8E6EC.5060702@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53F8E6EC.5060702@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/23/2014 03:09 PM, Douglas Gilbert wrote:
>> For inclusion in 3.17 only.
> May want to check if blk-mq work in lk 3.16 and earlier
> breaks the bsg driver's capability to send SCSI cdbs
> that are longer than 16 bytes.
>
>

I think 3.16 and earlier are OK.  The problem was caused by
scsi_mq_prep_fn(), which is new in 3.17.

Thanks for testing.

Tony
