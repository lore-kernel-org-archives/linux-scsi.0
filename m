From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] sg, bsg: mitigate read/write abuse, block uaccess in
 release
Date: Mon, 18 Jun 2018 17:16:58 +0100
Message-ID: <20180618161657.GP30522@ZenIV.linux.org.uk>
References: <20180615152335.208202-1-jannh@google.com>
 <20180615164009.GD30522@ZenIV.linux.org.uk>
 <90063ef3-68fa-e983-9b47-838e6076b0f4@interlog.com>
 <813e817b-bb2f-4a47-6225-9e39f19be278@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <813e817b-bb2f-4a47-6225-9e39f19be278@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: dgilbert@interlog.com, Jann Horn <jannh@google.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, security@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 18, 2018 at 09:37:01AM -0600, Jens Axboe wrote:

> > The folks responsible are no longer active in kernel development ***
> > but as far as I know the async write(command), read(response) were
> > added to bsg over 10 years ago as proof-of-concept and never properly
> > worked in this async mode. The biggest design problem with it that I'm
> 
> It was born with that mode, but I don't think anyone ever really used it.
> So it might feasible to simply yank it. That said, just doing a prune
> mode at ->release() time doesn't seem like such a hard task.

"prune mode" being...?
