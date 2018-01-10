From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [RESEND PATCH 1/2] scsi: bnx2fc: Use zeroing allocator rather
 than allocator/memset
Date: Wed, 10 Jan 2018 08:50:03 -0500 (EST)
Message-ID: <alpine.OSX.2.00.1801100848260.784@n1112sj6n01sf2.qlogic.org>
References: <1515488812-22664-1-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0060.outbound.protection.outlook.com ([104.47.32.60]:10907
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752020AbeAJNuZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jan 2018 08:50:25 -0500
In-Reply-To: <1515488812-22664-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com, Manish.Rangankar@cavium.com


On Tue, 9 Jan 2018, 4:06am, Himanshu Jha wrote:

> Use dma_zalloc_coherent instead of dma_alloc_coherent followed by
> memset 0.
> 
> Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
> 
> Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_hwi.c | 60 +++++++++++++++++-----------------------
>  drivers/scsi/bnx2fc/bnx2fc_tgt.c | 51 +++++++++++++++-------------------
>  2 files changed, 47 insertions(+), 64 deletions(-)
> 

Sorry, didn't realize I needed to ack the resend.

Acked-by: Chad Dupuis <chad.dupuis@cavium.com>
