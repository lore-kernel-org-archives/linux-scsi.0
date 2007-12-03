From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 26/28] blk_end_request: changing ide-cd (take 3)
Date: Mon, 03 Dec 2007 18:55:48 +0300
Message-ID: <47542704.2030602@ru.mvista.com>
References: <20071130.183447.82055860.k-ueda@ct.jp.nec.com> <200712012342.52134.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200712012342.52134.bzolnier@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> [PATCH] ide-cd: remove dead post_transform_command()

> post_transform_command() call in cdrom_newpc_intr() has no effect because
> it is done after the request has already been fully completed (rq->bio and
> rq->data are always NULL).  It was verified to be true regardless whether
> INQUIRY command is using DMA or PIO to transfer data (by using modified
> Tejun Heo's test-shortsg.c utility and adding a few printk()-s to ide-cd).

> This was uncovered thanks to the "blk_end_request: full I/O completion
> handler (take 3)" patch series from Kiyoshi Ueda.

> Cc: jens.axboe@oracle.com
> Cc: bharrosh@panasas.com
> Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com
> Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: Tejun Heo <htejun@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
