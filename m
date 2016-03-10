From: ygardi@codeaurora.org
Subject: Re: [PATCH v7 06/17] scsi: ufs: separate device and host quirks
Date: Thu, 10 Mar 2016 15:36:28 -0000
Message-ID: <bf47e6fb4f534bf91bb11720c53266cf.squirrel@us.codeaurora.org>
References: <1457440568-13084-1-git-send-email-ygardi@codeaurora.org>
    <1457440568-13084-7-git-send-email-ygardi@codeaurora.org>
    <yq1r3fjqdq7.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <yq1r3fjqdq7.fsf@sermon.lab.mkp.net>
Sender: linux-arm-msm-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Martin,

the only way i can avoid the circular dependency is to
move the routines from ufs_quirks.c into ufshcd.c.

i will upload V8 soon

thanks,
Yaniv


>>>>>> "Yaniv" == Yaniv Gardi <ygardi@codeaurora.org> writes:
>
> Yaniv> Currently we use the host quirks mechanism in order to handle
> Yaniv> both device and host controller quirks.  In order to support
> Yaniv> various of UFS devices we should separate handling the device
> Yaniv> quirks from the host controller's.
>
> This patch causes a circular dependency:
>
> depmod: ERROR: Cycle detected: ufshcd -> ufs_quirks -> ufshcd
>
> Please fix!
>
> --
> Martin K. Petersen	Oracle Linux Engineering
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
