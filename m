From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] scsi: Add scsi_prot_op_normal()
Date: Tue, 20 Nov 2018 08:19:40 -0800
Message-ID: <20181120161940.GA10454@infradead.org>
References: <1542725944-244183-1-git-send-email-john.garry@huawei.com>
 <1542725944-244183-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1542725944-244183-2-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +static inline bool scsi_prot_op_normal(struct scsi_cmnd *scmd)
> +{
> +	return scmd->prot_op == SCSI_PROT_NORMAL;
> +}

This "wrapper" just obsfucates the check being performed, please drop
it.
