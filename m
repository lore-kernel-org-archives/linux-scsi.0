From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: remove useless code in lpfc_sli4_bsg_link_diag_test
Date: Wed, 23 Aug 2017 22:45:46 -0400
Message-ID: <yq1d17ladk5.fsf@oracle.com>
References: <20170822205353.GA17794@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170822205353.GA17794@embeddedgus> (Gustavo A. R. Silva's
        message of "Tue, 22 Aug 2017 15:53:53 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo,

> Remove variable assignments. The value stored in local variable _rc_
> is overwritten at line 2448:rc =
> lpfc_sli4_bsg_set_link_diag_state(phba, 0); before it can be used.

Applied to 4.14/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
