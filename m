From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: hisi_sas: Fix NULL pointer dereference
Date: Fri, 19 Oct 2018 18:28:38 -0400
Message-ID: <yq1efclinah.fsf@oracle.com>
References: <20181018165939.GA26491@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181018165939.GA26491@embeddedor.com> (Gustavo A. R. Silva's
        message of "Thu, 18 Oct 2018 18:59:39 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Xiang Chen <chenxiang66@hisilicon.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo,

> There is a NULL pointer dereference in case *slot* happens to
> be NULL at lines 1053 and 1878:
>
> struct hisi_sas_cq *cq =
> 	&hisi_hba->cq[slot->dlvry_queue];
>
> Notice that *slot* is being NULL checked at lines 1057 and 1881:
> if (slot), which implies it may be NULL.
>
> Fix this by placing the declaration and definition of variable cq,
> which contains the pointer dereference slot->dlvry_queue, after
> slot has been properly NULL checked.

Applied to 4.20/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
