From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: bnx2i: bnx2i_hwi: use swap macro in bnx2i_send_iscsi_nopout
Date: Mon, 20 Nov 2017 21:28:11 -0500
Message-ID: <yq1r2ssnz5w.fsf@oracle.com>
References: <20171103195839.GA23385@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171103195839.GA23385@embeddedor.com> (Gustavo A. R. Silva's
        message of "Fri, 3 Nov 2017 14:58:39 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo A.,

> Make use of the swap macro and remove unnecessary variable tmp.
> This makes the code easier to read and maintain.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
