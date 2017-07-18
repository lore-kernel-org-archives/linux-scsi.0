From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH v2 08/15] megaraid_sas: Use SMID for Task abort case only
Date: Tue, 18 Jul 2017 16:36:15 +0530
Message-ID: <ec668eb4a7e9b4093db80c84aa44ba19@mail.gmail.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1499256029-16319-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:36000 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751462AbdGRLGR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jul 2017 07:06:17 -0400
Received: by mail-qk0-f182.google.com with SMTP id d136so13067391qkg.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2017 04:06:17 -0700 (PDT)
In-Reply-To: <1499256029-16319-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com, hch@lst.de

> -----Original Message-----
> From: Shivasharan S [mailto:shivasharan.srikanteshwara@broadcom.com]
> Sent: Wednesday, July 05, 2017 5:30 PM
> To: linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; thenzl@redhat.com;
> jejb@linux.vnet.ibm.com; kashyap.desai@broadcom.com;
> sumit.saxena@broadcom.com; hare@suse.com; hch@lst.de; Shivasharan S
> Subject: [PATCH v2 08/15] megaraid_sas: Use SMID for Task abort case
only
>
> Fix - In TM code, smid_task is valid only in case of task aborts.
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Hi Tomas,
Looks like this one patch got missed during your review.
Can you please review if the changes in this patch are fine?

Thanks,
Shivasharan
