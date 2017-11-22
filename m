From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: ufshcd: fix potential NULL pointer dereference in ufshcd_config_vreg
Date: Tue, 21 Nov 2017 23:01:15 -0500
Message-ID: <yq1fu97klmc.fsf@oracle.com>
References: <20171120141229.GA2130@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171120141229.GA2130@embeddedor.com> (Gustavo A. R. Silva's
        message of "Mon, 20 Nov 2017 08:12:29 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo A.,

> _vreg_ is being dereferenced before it is null checked, hence there is a
> potential null pointer dereference.
>
> Fix this by moving the pointer dereference after _vreg_ has been null
> checked.

Applied to 4.15/scsi-fixes, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
