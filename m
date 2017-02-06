From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 22/39] megaraid_sas: latest controller OCR capability from
 FW before sending shutdown DCMD
Date: Mon, 6 Feb 2017 16:50:22 +0100
Message-ID: <22788162-3ddc-8db2-59ea-f0d9cf90874a@redhat.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-23-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752109AbdBFPuZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Feb 2017 10:50:25 -0500
In-Reply-To: <1486375212-17329-23-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com

On 6.2.2017 10:59, Shivasharan S wrote:
> Fetch the latest controller OCR capability from FW before
> sending MR_DCMD_CTRL_SHUTDOWN
> When application sends a shutdown DCMD (MR_DCMD_CTRL_SHUTDOWN),
> driver will fetch latest controller information from firmware.
> This is to ensure that driver always has latest OCR capability
> of controller before sending the DCMD.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
