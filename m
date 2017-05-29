From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: Fix crash on PCI hotplug remove path
Date: Mon, 29 May 2017 16:11:11 -0700
Message-ID: <ad52a01e-8b2c-6ca8-3d63-c76d9c144ba6@broadcom.com>
References: <20170528214554.24336-1-gpiccoli@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35842 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdE2XLM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2017 19:11:12 -0400
Received: by mail-oi0-f54.google.com with SMTP id h4so92179910oib.3
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2017 16:11:11 -0700 (PDT)
In-Reply-To: <20170528214554.24336-1-gpiccoli@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: raphasil@linux.vnet.ibm.com, dick.kennedy@broadcom.com, jsmart2021@gmail.com, porcusbr@gmail.com

looks good

Signed-off-by: James Smart  <james.smart@broadcom.com>

-- james



On 5/28/2017 2:45 PM, Guilherme G. Piccoli wrote:
> During a PCI hotplug remove event we could have a NULL pointer
> dereference on lpfc_sli_abort_iocb(), if pring is NULL. This
> patch adds a check for this case and is able to circumvent the
> failure and continue the hotplug remove process with success.
>
> This issue was introduced after the driver refactor made on
> commit 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications").
>
> Fixes: 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications")
> Reported-by: Naresh Bannoth <nbannoth@in.ibm.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
> ---
> This patch was rebased against Martin's 4.12/scsi-fixes.
>
>
