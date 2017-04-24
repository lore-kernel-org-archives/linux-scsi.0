From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2] scsi: mpt3sas: remove redundant wmb
Date: Mon, 24 Apr 2017 18:32:41 -0400
Message-ID: <yq1d1c1h1x2.fsf@oracle.com>
References: <1491591978-17880-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1491591978-17880-1-git-send-email-okaya@codeaurora.org> (Sinan
        Kaya's message of "Fri, 7 Apr 2017 15:06:18 -0400")
Sender: linux-arm-msm-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, timur@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:LSILOGIC MPT FUSION DRIVERS
        FC/SAS/SPI" <MPT-FusionLinux.pdl@broadcom.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Sinan,

> Due to relaxed ordering requirements on multiple architectures,
> drivers are required to use wmb/rmb/mb combinations when they need to
> guarantee observability between the memory and the HW.

Applied to 4.12/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
