From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 08/23] scsi: introduce a result field in struct scsi_request
Date: Wed, 19 Apr 2017 21:43:00 -0400
Message-ID: <yq160hzsvkr.fsf@oracle.com>
References: <20170419192708.22098-1-hch@lst.de>
        <20170419192708.22098-9-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44211 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764846AbdDTBnm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2017 21:43:42 -0400
In-Reply-To: <20170419192708.22098-9-hch@lst.de> (Christoph Hellwig's message
        of "Wed, 19 Apr 2017 21:26:53 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Roger Pau =?utf-8?Q?Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

Christoph Hellwig <hch@lst.de> writes:

> This passes on the scsi_cmnd result field to users of passthrough
> requests.  Currently we abuse req->errors for this purpose, but that
> field will go away in its current form.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

> Note that the old IDE code abuses the errors field in very creative
> ways and stores all kinds of different values in it.  I didn't dare
> to touch this magic, so the abuses are brought forward 1:1.

Really wish we could just obliterate drivers/ide.

-- 
Martin K. Petersen	Oracle Linux Engineering
