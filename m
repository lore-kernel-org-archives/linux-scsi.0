From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/4] scsi: arcmsr: simplify hba_get_config routine
Date: Thu, 14 Dec 2017 21:44:36 -0500
Message-ID: <yq1fu8cogkr.fsf@oracle.com>
References: <1513075193.5249.14.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513075193.5249.14.camel@Centos6.3-64> (Ching Huang's message of
        "Tue, 12 Dec 2017 18:39:53 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org


Ching,

> patch 1: simplify arcmsr_hbaC_get_config function.
>
> patch 2: wait iop firmware ready before issue get_config command to iop.
>
> patch 3: simplify arcmsr_hbaE_get_config function.
>
> patch 4: simplify all arcmsr_hbaX_get_config routine by call a new get_adapter_config function

Applied to 4.16/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
