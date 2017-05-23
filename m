From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] qla2xxx: Remove an unused structure member
Date: Tue, 23 May 2017 09:20:27 +0200
Message-ID: <20170523072027.GA18234@lst.de>
References: <20170522201053.7093-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52324 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935490AbdEWHU3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 May 2017 03:20:29 -0400
Content-Disposition: inline
In-Reply-To: <20170522201053.7093-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Quinn Tran <quinn.tran@cavium.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, David Disseldorp <ddiss@suse.de>

On Mon, May 22, 2017 at 01:10:53PM -0700, Bart Van Assche wrote:
> qla_tgt_cmd.free_work is not used by the qla2xxx driver. Hence
> remove that member of struct qla_tgt_cmd.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
