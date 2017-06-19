From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 4/6] qla2xxx: Send FC4 type NVMe to the management server
Date: Mon, 19 Jun 2017 14:23:55 -0700
Message-ID: <42dd8f9b-0c88-307c-f271-00c37e97a04f@broadcom.com>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
 <20170616224744.3681-5-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38767 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbdFSVYA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jun 2017 17:24:00 -0400
Received: by mail-wm0-f43.google.com with SMTP id u195so4212789wmd.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jun 2017 14:23:59 -0700 (PDT)
In-Reply-To: <20170616224744.3681-5-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, giridhar.malaval@cavium.com, darren.trapp@cavium.com

On 6/16/2017 3:47 PM, Himanshu Madhani wrote:
> From: Duane Grigsby <duane.grigsby@cavium.com>
>
> This patch adds switch command support for FC-4 type of FC-NVMe (0x28)
> for resgistering HBA port to the management server. RFT_ID command is
> used to register FC-4 type of 0x28 and RFF_ID is used to register
> FC-4 features bits for FC-NVMe port.
>
> Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
> Signed-off-by: Anil Gurumurthy <anil.gurumurhty@cavium.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>

Reviewed-By: James Smart <james.smart@broadcom.com>
