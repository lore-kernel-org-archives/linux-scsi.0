From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: fix potential buffer overflow.
Date: Tue, 18 Apr 2017 14:15:28 -0700
Message-ID: <6b822fc4-2b87-4176-b9ba-b25945bcc2c1@broadcom.com>
References: <1492509351-25441-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:35388 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757533AbdDRVPe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 17:15:34 -0400
Received: by mail-wr0-f181.google.com with SMTP id o21so3232994wrb.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2017 14:15:34 -0700 (PDT)
In-Reply-To: <1492509351-25441-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: dick.kennedy@broadcom.com, linux-scsi@vger.kernel.org, emilne@redhat.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com



On 4/18/2017 2:55 AM, Maurizio Lombardi wrote:
> This patch fixes a potential buffer overflow in lpfc_nvme_info_show().
>
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>

looks fine

-- james

Signed-off-by: James Smart <james.smart@broadcom.com>
