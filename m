From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] qla2xxx: remove dead code, add missing statics
Date: Mon, 06 Dec 2004 16:09:53 -0800
Message-ID: <1102378193.12525.31.camel@plap.san.rr.com>
References: <20041101143100.GA10168@lst.de>  <20041206152357.GA11705@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:40861 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261712AbULGAYL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Dec 2004 19:24:11 -0500
In-Reply-To: <20041206152357.GA11705@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Mon, 2004-12-06 at 16:23 +0100, Christoph Hellwig wrote:
> ping
> 
> 
> ===== drivers/scsi/qla2xxx/qla_devtbl.h 1.2 vs edited =====
> --- 1.2/drivers/scsi/qla2xxx/qla_devtbl.h	2004-03-12 18:08:32 +01:00
> +++ edited/drivers/scsi/qla2xxx/qla_devtbl.h	2004-10-20 23:40:56 +02:00


Could you hold off on adding this patch as-is as it conflicts with
several patches I have queued up for submission -- which I plan to
upload for submission by mid-week.

I'll integrate a slightly modded form of this patch then.

Thanks for you patience...
Andrew

