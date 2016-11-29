From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: megaraid-sas: fix spelling mistake of "outstanding"
Date: Tue, 29 Nov 2016 11:09:19 -0800
Message-ID: <57f570c5-7057-6354-545f-6113f0694c66@sandisk.com>
References: <20161129190052.8596-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0066.outbound.protection.outlook.com ([104.47.33.66]:40992
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752106AbcK2TJc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Nov 2016 14:09:32 -0500
In-Reply-To: <20161129190052.8596-1-colin.king@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

On 11/29/2016 11:00 AM, Colin King wrote:
>  		scmd_printk(KERN_NOTICE, scmd, "Command for which abort is"
> -			" issued is not found in oustanding commands\n");
> +			" issued is not found in outstanding commands\n");

Hello Colin,

Since you are changing this code, please ensure that the entire error 
message occupies a single line such that it is easy to find with grep.

Bart.
