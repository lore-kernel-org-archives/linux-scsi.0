From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 09/12] Make scsi_mq_prep_fn() call
        scsi_init_command()
Date: Mon, 5 Jun 2017 10:10:01 +0200
Message-ID: <20170605081001.GC22028@lst.de>
References: <20170602212203.30401-1-bart.vanassche@sandisk.com> <20170602212203.30401-10-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38671 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751336AbdFEIKD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Jun 2017 04:10:03 -0400
Content-Disposition: inline
In-Reply-To: <20170602212203.30401-10-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
