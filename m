From: Johannes Thumshirn <jth@kernel.org>
Subject: Re: [PATCH 3/5] scsi: bnx2fc: clean up header definitions
Date: Fri, 5 May 2017 12:33:51 +0200
Message-ID: <a9ea0025-cd86-930e-1a04-66aa5cdd4b54@kernel.org>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
 <20170410171254.30367-4-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35365 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751752AbdEEKd6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2017 06:33:58 -0400
Received: by mail-wm0-f67.google.com with SMTP id b10so477691wmh.2
        for <linux-scsi@vger.kernel.org>; Fri, 05 May 2017 03:33:57 -0700 (PDT)
In-Reply-To: <20170410171254.30367-4-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: rt@linutronix.de, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>


On 04/10/2017 07:12 PM, Sebastian Andrzej Siewior wrote:
> - All symbols which are only used within one .c file are marked static
>   and removed from the bnx2fc.h file if possible.
>
> - the declarion of bnx2fc_percpu is moved into the header file
>
> This patch was only compile-tested due to -ENODEV.
>
> Cc: QLogic-Storage-Upstream@qlogic.com
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
