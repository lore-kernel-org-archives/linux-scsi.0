From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sg, bsg: mitigate read/write abuse, block uaccess in
 release
Date: Tue, 10 Jul 2018 23:33:07 -0700
Message-ID: <20180711063307.GA31127@infradead.org>
References: <20180615152335.208202-1-jannh@google.com>
 <20180615164009.GD30522@ZenIV.linux.org.uk>
 <90063ef3-68fa-e983-9b47-838e6076b0f4@interlog.com>
 <813e817b-bb2f-4a47-6225-9e39f19be278@kernel.dk>
 <20180621123431.GA558@infradead.org>
 <36a641db-fb1d-6c4c-7f1b-172f2b1cde32@kernel.dk>
 <20180708145840.GA22949@infradead.org>
 <CAG48ez0ahgHZAEYHt_J_MAanRNX+PXN+2MwtR-VM=gm8Ym30kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez0ahgHZAEYHt_J_MAanRNX+PXN+2MwtR-VM=gm8Ym30kg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, Douglas Gilbert <dgilbert@interlog.com>, Al Viro <viro@zeniv.linux.org.uk>, fujita.tomonori@lab.ntt.co.jp, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, security@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 10, 2018 at 01:53:02PM -0700, Jann Horn wrote:
> With the error messages like in my sg patch or like with Linus'
> proposed patch (https://lore.kernel.org/lkml/CA+55aFwg-2GP4ASTdd1pusmZkF7c8AN9febVDCaioDxzYJSLfw@mail.gmail.com/)
> applied?

I guess we should follows Linus' suggestions.

Note that he also seems to agree with me to just remove the read/write
interface.  Compared to sg bsg really is unused for the read/write
interface.  But lets get your fix in first..
