From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v4] bsg: mitigate read/write abuse, block uaccess in release
Date: Mon, 16 Jul 2018 18:57:34 +0200
Message-ID: <CAG48ez3HEcp-hE=JF4T+7wjLju_NtLXqh8fvroEPBmx1P2D9Hw@mail.gmail.com>
References: <20180716165154.58794-1-jannh@google.com> <CA+55aFy21E78DTF-3+1P3bTtX_89-nFUSpYHUELT0WCOZ-ccjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFy21E78DTF-3+1P3bTtX_89-nFUSpYHUELT0WCOZ-ccjw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, Al Viro <viro@zeniv.linux.org.uk>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, Kernel Hardening <kernel-hardening@lists.openwall.com>, security@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 16, 2018 at 6:55 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Jul 16, 2018 at 9:52 AM Jann Horn <jannh@google.com> wrote:
> >
> > But bsg doesn't just do it on ->write(), also on ->read() and ->release().
>
> I think Jens already applied Christoph's patch to just remove the bsg
> read/write entirely into the 4.19 tree.

I thought Christoph wanted this one for stable. Maybe I misunderstood.
