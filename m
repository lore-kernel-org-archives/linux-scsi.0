From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v4] bsg: mitigate read/write abuse, block uaccess in release
Date: Mon, 16 Jul 2018 10:19:19 -0700
Message-ID: <CA+55aFxeJxC0SNv9o4RYZkwmRA15SBg0cw=kHgO-omAjg2RDgQ@mail.gmail.com>
References: <20180716165154.58794-1-jannh@google.com> <CA+55aFy21E78DTF-3+1P3bTtX_89-nFUSpYHUELT0WCOZ-ccjw@mail.gmail.com>
 <CAG48ez3HEcp-hE=JF4T+7wjLju_NtLXqh8fvroEPBmx1P2D9Hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez3HEcp-hE=JF4T+7wjLju_NtLXqh8fvroEPBmx1P2D9Hw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-block <linux-block@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>, Al Viro <viro@zeniv.linux.org.uk>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, security@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 16, 2018 at 9:58 AM Jann Horn <jannh@google.com> wrote:
>
> I thought Christoph wanted this one for stable. Maybe I misunderstood.

If we can remove it in mainline, we should remove it in stable too.
There's no situation where compatibility would matter in stable but
not in mainline.

            Linus
