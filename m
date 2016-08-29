From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: move function declarationes to scsi_priv.h
Date: Mon, 29 Aug 2016 08:58:57 -0700
Message-ID: <204f29e4-f582-5961-b62c-b0bf9de67b86@sandisk.com>
References: <1472317197-7865-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0043.outbound.protection.outlook.com ([104.47.38.43]:23424
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753937AbcH2P7U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Aug 2016 11:59:20 -0400
In-Reply-To: <1472317197-7865-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@linaro.org, xie.baoyou@zte.com.cn

On 08/27/2016 09:59 AM, Baoyou Xie wrote:
> We get 2 warnings about global functions without a declaration
> in the scsi driver when building with W=1:
> drivers/scsi/scsi_lib.c:467:6: warning: no previous prototype for 'scsi_requeue_run_queue' [-Wmissing-prototypes]
> drivers/scsi/scsi_lib.c:2609:6: warning: no previous prototype for 'scsi_evt_thread' [-Wmissing-prototypes]
>
> in fact, both functiones are declared in drivers/scsi/scsi_scan.c
> but need to move the declarationes into scsi_priv.h.

Please fix the spelling in the patch title and description (functiones 
-> functions and declarationes -> declarations). Anyway:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

