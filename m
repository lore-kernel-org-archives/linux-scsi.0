From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH 11/39] megaraid_sas: NVME interface target prop added
Date: Mon, 6 Feb 2017 16:04:53 +0530
Message-ID: <5850f68f308fc69f9167b6298cfcc0b9@mail.gmail.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:34499 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750956AbdBFKez (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:34:55 -0500
Received: by mail-qt0-f173.google.com with SMTP id w20so95870461qtb.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:34:54 -0800 (PST)
In-Reply-To: <1486375212-17329-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com

> -----Original Message-----
> From: Shivasharan S [mailto:shivasharan.srikanteshwara@broadcom.com]
> Sent: Monday, February 06, 2017 3:30 PM
> To: linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; thenzl@redhat.com;
> jejb@linux.vnet.ibm.com; kashyap.desai@broadcom.com;
> sumit.saxena@broadcom.com; hare@suse.com; Shivasharan S
> Subject: [PATCH 11/39] megaraid_sas: NVME interface target prop added
>
> This patch depends on patch 0008.
> This patch fetch true values of NVME property from FW using New DCMD
> interface MR_DCMD_DEV_GET_TARGET_PROP

Correction: By mistake I have sent this patch with the commit description
of patch 10.
See below the updated title and description:
megaraid_sas: NVME fast path io support

This patch depends on patch 0008, 0009.
This patch provide true fast path IO support.  Driver creates PRP for NVME
drives and send Fast Path for performance.
Certain h/w requirement needs to be taken care in driver.

I will resend this patch with above changes.
Waiting for review to be completed and accumulate all the feedback.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
