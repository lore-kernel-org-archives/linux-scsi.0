From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: qla1280 compile problems
Date: 05 Aug 2003 09:17:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060100259.2044.3.camel@fuzzy>
References: <20030805121813.GA24647@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:17926 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S272819AbTHEQRs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2003 12:17:48 -0400
In-Reply-To: <20030805121813.GA24647@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jes Sorensen <jes@wildopensource.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-08-05 at 05:18, Christoph Hellwig wrote:
> The qla1280 update still has some issues, mostly because it backs
> out all the 2.5 changes applied to the driver in the last months,
> also it doesn't work on ia64 because the IA64 generic build references
> sn2-specific symbols that don't exist in that build.

Could you be more explicit on this?  I thought I'd re-added all of the
backed out patches (although I might have missed some).

> In file included from drivers/scsi/qla1280.c:299:
> include/linux/blk.h:1:2: warning: #warning this file is obsolete, please use <linux/blkdev.h> instead
> drivers/scsi/qla1280.c: In function `qla1280_done':
> drivers/scsi/qla1280.c:1833: warning: implicit declaration of function `qla1280_get_target_options'
> drivers/scsi/qla1280.c: At top level:
> drivers/scsi/qla1280.c:4506: warning: type mismatch with previous implicit declaration
> drivers/scsi/qla1280.c:1833: warning: previous implicit declaration of `qla1280_get_target_options'
> drivers/scsi/qla1280.c:4506: warning: `qla1280_get_target_options' was previously implicitly declared to return `int'
> drivers/scsi/qla1280.c:4830: warning: initialization from incompatible pointer type
> drivers/scsi/qla1280.c:4830: error: unknown field `command' specified in initializer

For what it's worth, this compiled for me without warnings on parisc64
(although I haven't got around to actually testing it).

James


