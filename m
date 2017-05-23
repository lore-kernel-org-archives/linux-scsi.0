From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: hisi_sas: add null check before indirect pointer
 dereference
Date: Tue, 23 May 2017 08:43:57 +0100
Message-ID: <93be1808-c4f8-dbb4-f928-ac3a1f5f474c@huawei.com>
References: <20170522180029.GA19381@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170522180029.GA19381@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 22/05/2017 19:00, Gustavo A. R. Silva wrote:
> Add null check before indirectly dereferencing pointer task->lldd_task
> in statement u32 tag = slot->idx;
>

I don't think that this is a valid scenario, but protecting against a 
possible NULL dereference is prudent. Thanks

> Addresses-Coverity-ID: 1373843
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

Reviewed-by: John Garry <john.garry@huawei.com>
