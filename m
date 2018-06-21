From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sg, bsg: mitigate read/write abuse, block uaccess in
 release
Date: Thu, 21 Jun 2018 05:40:36 -0700
Message-ID: <20180621124036.GA6348@infradead.org>
References: <20180615152335.208202-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180615152335.208202-1-jannh@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, kernel-hardening@lists.openwall.com, security@kernel.org
List-Id: linux-scsi@vger.kernel.org

Can you resend a patch for the sg driver alone?  Also I think
we just want the scsi_safe_file_access code inside sg itself,
it really has nothing to do with the reset of the contents in
scsi_cmnd.h
