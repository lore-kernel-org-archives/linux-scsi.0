From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] sg, bsg: mitigate read/write abuse, block uaccess in release
Date: Thu, 21 Jun 2018 14:54:05 +0200
Message-ID: <CAG48ez0Ps6ib=8_fGJbdk7w--7MNkhkvE1PG6hk=fJ=ZoEtFNQ@mail.gmail.com>
References: <20180615152335.208202-1-jannh@google.com> <20180621124036.GA6348@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621124036.GA6348@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp, dgilbert@interlog.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Kernel Hardening <kernel-hardening@lists.openwall.com>, security@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 21, 2018 at 2:40 PM Christoph Hellwig <hch@infradead.org> wrote:
> Can you resend a patch for the sg driver alone?

Okay, will do.

> Also I think
> we just want the scsi_safe_file_access code inside sg itself,
> it really has nothing to do with the reset of the contents in
> scsi_cmnd.h

Okay. (I put it there because I couldn't figure out a better common
header and didn't want to create two new copies of the code.)
