From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH] [SCSI] bsg: fix unkillable I/O wait deadlock with scsi-mq
Date: Fri, 13 Feb 2015 17:09:15 -0500
Message-ID: <54DE760B.1000709@cybernetics.com>
References: <54DB83F5.50104@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54DB83F5.50104@cybernetics.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/11/2015 11:31 AM, Tony Battersby wrote:
> Note: I did a number of tests with this patch, but I do not have any
> programs to test commands with bidirectional data transfer.  I would
> appreciate if someone could test that.

Replying to myself, I was able to test bidirectional data transfer using
scsi_debug and sg_raw, and it worked just fine.

Tony
