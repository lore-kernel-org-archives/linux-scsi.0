From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 3/3] [SCSI] mpt2sas: Remove unnecessary use of a boolean
 variable
Date: Fri, 19 Dec 2014 04:26:31 -0800
Message-ID: <1418991991.25129.10.camel@perches.com>
References: <20141219111345.GA19938@sloth>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20141219111345.GA19938@sloth>
Sender: kernel-janitors-owner@vger.kernel.org
To: Quentin Lambert <lambert.quentin@gmail.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-12-19 at 12:13 +0100, Quentin Lambert wrote:
[]
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
[]
> @@ -1414,12 +1414,8 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
>  	struct msix_entry *entries, *a;
>  	int r;
>  	int i;
> -	u8 try_msix = 0;
>  
> -	if (msix_disable == -1 || msix_disable == 0)
> -		try_msix = 1;
> -
> -	if (!try_msix)
> +	if (msix_disable != -1 || msix_disable != 0)
>  		goto try_ioapic;

logic not the same.

Now needs && not ||


