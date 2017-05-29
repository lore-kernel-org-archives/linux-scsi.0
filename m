From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: Avoid NULL pointer dereference in
 lpfc_els_abort()
Date: Mon, 29 May 2017 16:07:45 -0700
Message-ID: <78568a32-923a-acdc-c2b9-a57e18442bea@broadcom.com>
References: <20170524214851.25428-1-gpiccoli@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35511 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751218AbdE2XHq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2017 19:07:46 -0400
Received: by mail-oi0-f50.google.com with SMTP id l18so92133225oig.2
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2017 16:07:46 -0700 (PDT)
In-Reply-To: <20170524214851.25428-1-gpiccoli@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: raphasil@linux.vnet.ibm.com, dick.kennedy@broadcom.com, jsmart2021@gmail.com

Change looks good

Signed-off-by: James Smart  <james.smart@broadcom.com>

-- james


On 5/24/2017 2:48 PM, Guilherme G. Piccoli wrote:
> We might have a NULL pring in lpfc_els_abort(), for example on
> error recovery path, since queues are destroyed during error
> recovery mechanism.
>
> In this case, we should just drop the abort since the queues will
> be recreated anyway. This patch just verifies for NULL pointer
> and stop the abortion of the queue in case of a NULL pring.
>
> Also, this patch converts return type of lpfc_els_abort() from int
> to void, since it's not checked anywhere.
>
> Reported-by: Harsha Thyagaraja <hathyaga@in.ibm.com>
> Reported-by: Naresh Bannoth <nbannoth@in.ibm.com>
> Tested-by: Raphael Silva <raphasil@linux.vnet.ibm.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
>
