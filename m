From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH 11/39] megaraid_sas: NVME interface target prop added
Date: Mon, 6 Feb 2017 15:46:44 +0530
Message-ID: <a61fd0482acdd4e465b96303924fb20c@mail.gmail.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:34465 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750973AbdBFKQq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:16:46 -0500
Received: by mail-qk0-f171.google.com with SMTP id s186so49927158qkb.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:16:45 -0800 (PST)
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

Correction: This patch depends on patch 09: "megaraid_sas: NVME Interface
detection and prop settings"
> This patch fetch true values of NVME property from FW using New DCMD
> interface MR_DCMD_DEV_GET_TARGET_PROP
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
