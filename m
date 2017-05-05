From: Johannes Thumshirn <jth@kernel.org>
Subject: Re: [PATCH 4/5] scsi: bnx2fc: annoate unlock + release for sparse
Date: Fri, 5 May 2017 12:34:30 +0200
Message-ID: <ef48dc75-b492-865a-26f9-3364eec051dd@kernel.org>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
 <20170410171254.30367-5-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35786 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751788AbdEEKed (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2017 06:34:33 -0400
Received: by mail-wm0-f66.google.com with SMTP id b10so480819wmh.2
        for <linux-scsi@vger.kernel.org>; Fri, 05 May 2017 03:34:32 -0700 (PDT)
In-Reply-To: <20170410171254.30367-5-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: rt@linutronix.de, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>


On 04/10/2017 07:12 PM, Sebastian Andrzej Siewior wrote:
> The caller of bnx2fc_abts_cleanup() holds the tgt->tgt_lock lock and it
> is expected to release the lock during wait_for_completion() and acquire
> the lock afterwards.
>
> This patch was only compile-tested due to -ENODEV.
>
> Cc: QLogic-Storage-Upstream@qlogic.com
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
