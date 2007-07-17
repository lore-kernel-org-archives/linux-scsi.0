From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: block/bsg.c
Date: Wed, 18 Jul 2007 01:19:34 +0200
Message-ID: <200707180119.34984.bzolnier@gmail.com>
References: <20070717065940.GZ5195@kernel.dk> <200707172252.25729.bzolnier@gmail.com> <20070717143434.48836fb8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070717143434.48836fb8.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 17 July 2007, Andrew Morton wrote:
> On Tue, 17 Jul 2007 22:52:25 +0200
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > ide-{disk,scsi,tape} don't support REQ_TYPE_BLOCK_PC requests et all
> > (so attempts to use SG_IO, CDROM_SEND_PACKET and SCSI_IOCTL_SEND_COMMAND
> > will result in requests being failed and error messages in the kernel logs).
> 
> In my case it results in a completely tits-up machine.  CPU stuck somewhere
> spinning with local interrutps disabled.
> 
> If you see the log output I sent, I'm suspecting this might be because

I don't. :(

> this BSG brainfart has exposed underlying bugs in IDE or SCSI.

Possible but ATM I have an (overdue) IDE update to push, people waiting for
(overdue) patches to try and some (overdue) patches to finish and post...

Would be great if somebody beats me to investigate this issue.

Hint: this would be a great way to redempt pushing buggy commit behind
my back. ;-)

Thanks,
Bart
