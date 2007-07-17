From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 14:34:34 -0700
Message-ID: <20070717143434.48836fb8.akpm@linux-foundation.org>
References: <20070717065940.GZ5195@kernel.dk>
	<20070717190705T.fujita.tomonori@lab.ntt.co.jp>
	<20070717101928.GK5195@kernel.dk>
	<200707172252.25729.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200707172252.25729.bzolnier@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 17 Jul 2007 22:52:25 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> ide-{disk,scsi,tape} don't support REQ_TYPE_BLOCK_PC requests et all
> (so attempts to use SG_IO, CDROM_SEND_PACKET and SCSI_IOCTL_SEND_COMMAND
> will result in requests being failed and error messages in the kernel logs).

In my case it results in a completely tits-up machine.  CPU stuck somewhere
spinning with local interrutps disabled.

If you see the log output I sent, I'm suspecting this might be because
this BSG brainfart has exposed underlying bugs in IDE or SCSI.

Note that I saw literally 20,000 lines of output in the bit which I snipped,
so something has gone pretty wild in the handling of these bogus commands.

