From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 1/4] scsi: Add scsi_prot_op_normal()
Date: Tue, 20 Nov 2018 16:36:14 +0000
Message-ID: <4493598c-7c25-a1b1-dfbb-aaec0b967185@huawei.com>
References: <1542725944-244183-1-git-send-email-john.garry@huawei.com>
 <1542725944-244183-2-git-send-email-john.garry@huawei.com>
 <20181120161940.GA10454@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181120161940.GA10454@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 20/11/2018 16:19, Christoph Hellwig wrote:
>> +static inline bool scsi_prot_op_normal(struct scsi_cmnd *scmd)
>> +{
>> +	return scmd->prot_op == SCSI_PROT_NORMAL;
>> +}
>
> This "wrapper" just obsfucates the check being performed, please drop
> it.
>
> .
>

ok, if you think so.

I just thought that was better for a more concise check, rather than 
this common pattern:
if ((scsi_get_prot_op(scsi_cmnd) != SCSI_PROT_NORMAL) ...

cheers,
