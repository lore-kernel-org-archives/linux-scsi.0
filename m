From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/19] sd, sr: Convert two assignments into warning
        statements
Date: Thu, 24 Aug 2017 11:08:11 +0200
Message-ID: <20170824090811.GI19886@lst.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com> <20170823214009.15015-10-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48637 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751260AbdHXJIM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Aug 2017 05:08:12 -0400
Content-Disposition: inline
In-Reply-To: <20170823214009.15015-10-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>

On Wed, Aug 23, 2017 at 02:39:59PM -0700, Bart Van Assche wrote:
> Before scsi_prep_fn() calls the ULP .init_command() callback
> function it stores the SCSI command pointer in request.special.
> This means that the SCpnt = rq->special assignments in the sd
> and sr drivers assign a pointer to itself. Hence convert these
> two assignment statements into warning statements.

Looks good.

Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, in the longer run we should aim to kill the special pointer
in struct request entirely.
