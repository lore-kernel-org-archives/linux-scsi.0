From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] ide-scsi: remove kmalloced struct request
Date: Tue, 22 Jul 2008 22:17:10 +0200
Message-ID: <200807222217.11189.bzolnier@gmail.com>
References: <20080423114425E.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080423114425E.tomof@acm.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 23 April 2008, FUJITA Tomonori wrote:
> This converts ide-scsi to use blk_get/put_request instead of
> kmalloc/kfree as discussed in the large command support thread:
> 
> http://marc.info/?l=linux-scsi&m=120817161219068&w=2
> 
> This patch is a sequel to my patchset to remove struct request on the
> stack:
> 
> http://marc.info/?l=linux-ide&m=120882410712466&w=2
> 
> ===
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] ide-scsi: remove kmalloced struct request
> 
> This converts ide-scsi to use blk_get/put_request instead of
> kmalloc/kfree.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

I found it during mailbox cleanup - seems like somehow it got lost
from blk_get/put_request merge.  I applied it now (after fixing rejects).
