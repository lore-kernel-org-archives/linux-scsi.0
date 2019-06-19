From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: megaraid_sas: Use struct_size() helper
Date: Tue, 18 Jun 2019 22:45:08 -0400
Message-ID: <yq1h88mwax7.fsf@oracle.com>
References: <20190607184053.GA11513@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190607184053.GA11513@embeddedor> (Gustavo A. R. Silva's
        message of "Fri, 7 Jun 2019 13:40:53 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo,

> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
>
> struct MR_PD_CFG_SEQ_NUM_SYNC {
> 	...
>         struct MR_PD_CFG_SEQ seq[1];
> } __packed;
>
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes.

Applied to 5.3/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
