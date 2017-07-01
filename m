From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: lpfc: spin_lock_irq() is not nestable
Date: Sat, 01 Jul 2017 17:09:45 -0400
Message-ID: <yq1y3s7vp7q.fsf@oracle.com>
References: <20170630080250.mjbosf64qlytrsii@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170630080250.mjbosf64qlytrsii@mwanda> (Dan Carpenter's message
        of "Fri, 30 Jun 2017 11:02:51 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Dan,

> We're calling spin_lock_irq() multiple times, the problem is that on
> the first spin_unlock_irq() then we will re-enable IRQs and we don't
> want that.

Applied to 4.13/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
