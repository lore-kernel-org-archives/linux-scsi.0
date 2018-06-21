From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sg, bsg: mitigate read/write abuse, block uaccess in
 release
Date: Thu, 21 Jun 2018 06:03:27 -0700
Message-ID: <20180621130327.GB24925@infradead.org>
References: <20180615152335.208202-1-jannh@google.com>
 <20180615164009.GD30522@ZenIV.linux.org.uk>
 <90063ef3-68fa-e983-9b47-838e6076b0f4@interlog.com>
 <813e817b-bb2f-4a47-6225-9e39f19be278@kernel.dk>
 <20180621123431.GA558@infradead.org>
 <CAG48ez3BWeZkW5XG814K4o7p0KWXVm9Gpzh2rTthNei=4fhH-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez3BWeZkW5XG814K4o7p0KWXVm9Gpzh2rTthNei=4fhH-A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, dgilbert@interlog.com, Al Viro <viro@zeniv.linux.org.uk>, fujita.tomonori@lab.ntt.co.jp, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, security@kernel.org, Alexander Nezhinsky <alexandern@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>, stgt@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 21, 2018 at 02:51:16PM +0200, Jann Horn wrote:
> In the package https://packages.debian.org/stretch/tgt:
>   https://sources.debian.org/src/tgt/1:1.0.73-1/usr/bs_sg.c/?hl=131#L131
>   https://sources.debian.org/src/tgt/1:1.0.73-1/usr/bs_sg.c/?hl=236#L236

This is for real, although it is an optional case in an optional plug
in, so I'm not sure if any one actually uses bsg read/write with it
for real.

The usual aspects added. (the question is if bsg read/write support
is actually used in real life or can be removed)

> In the package https://packages.debian.org/stretch/sg3-utils:
>   https://sources.debian.org/src/sg3-utils/1.42-2/examples/bsg_queue_tst.c/?hl=60#L60

This is just example code.
