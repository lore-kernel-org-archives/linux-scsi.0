From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 1/2] scsi: lpfc: spin_lock_irq() is not nestable
Date: Fri, 30 Jun 2017 07:56:29 -0700
Message-ID: <89beb27c-0844-1bba-dcf3-4f64c167782c@broadcom.com>
References: <20170630080250.mjbosf64qlytrsii@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:33585 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbdF3O4e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jun 2017 10:56:34 -0400
Received: by mail-wm0-f53.google.com with SMTP id z75so25625527wmc.0
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jun 2017 07:56:33 -0700 (PDT)
In-Reply-To: <20170630080250.mjbosf64qlytrsii@mwanda>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On 6/30/2017 1:02 AM, Dan Carpenter wrote:
> We're calling spin_lock_irq() multiple times, the problem is that on the
> first spin_unlock_irq() then we will re-enable IRQs and we don't want
> that.
>
> Fixes: 966bb5b71196 ("scsi: lpfc: Break up IO ctx list into a separate get and put list")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>

looks good.

Signed-off-By: James Smart <james.smart@broadcom.com>
