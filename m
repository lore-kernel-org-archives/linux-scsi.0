From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/4] scsi: arcmsr: Support Areca thunderbolt devices hot-plug
Date: Wed, 21 Mar 2018 18:47:22 -0400
Message-ID: <yq17eq5rqpx.fsf@oracle.com>
References: <1521095129.31371.25.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521095129.31371.25.camel@Centos6.3-64> (Ching Huang's message
        of "Thu, 15 Mar 2018 14:25:29 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org


Ching,

> 1. Rename ACB_F_BUS_HANG_ON to ACB_F_ADAPTER_REMOVED for adapter hot-plug
> 2. Handle adapter removed due to thunderbolt cable disconnection.
> 3. Sleep to avoid CPU stuck too long for waiting adapter ready
> 4. Change driver version to v1.40.00.05-20180309

Applied to 4.17/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
