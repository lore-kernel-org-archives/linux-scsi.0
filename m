From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qedi: Limit number for CQ queues.
Date: Thu, 10 Aug 2017 20:22:05 -0400
Message-ID: <yq18tir2bte.fsf@oracle.com>
References: <20170810133217.31481-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25026 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751391AbdHKAWV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2017 20:22:21 -0400
In-Reply-To: <20170810133217.31481-1-manish.rangankar@cavium.com> (Manish
        Rangankar's message of "Thu, 10 Aug 2017 06:32:17 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Manish Rangankar <manish.rangankar@cavium.com>
Cc: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com, linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com


Manish,

> [qed_sp_iscsi_func_start:189(host_7-0)]Cannot satisfy CQ amount. Queues
> requested 8, CQs available 4. Aborting function start
>
> Above condition will resolve as management firmware is capable of telling
> us the number of CQs available for a given PF, qed will communicate the
> same number to qedi, So that qedi will know how much CQs are allowed.

Applied to 4.14/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
