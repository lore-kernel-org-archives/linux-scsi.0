From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH] scsi: mpt3sas: remove redundant wmb on arm/arm64
Date: Fri, 7 Apr 2017 12:51:01 -0400
Message-ID: <a335dc48-45e0-bfde-87df-f6931889325b@codeaurora.org>
References: <1491583306-20551-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1491583306-20551-1-git-send-email-okaya@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, timur@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)" <MPT-FusionLinux.pdl@broadcom.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 4/7/2017 12:41 PM, Sinan Kaya wrote:
> The right thing was to either call __raw_writel/__raw_readl or
> write_relaxed/read_relaxed for multi-arch compatibility.

One can also argue to get rid of wmb(). I can go either way based
on the recommendation.

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
