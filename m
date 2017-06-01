From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 14/23] scsi: hisi_sas: add v3 cq interrupt handler
Date: Wed, 31 May 2017 22:41:48 -0700
Message-ID: <20170601054147.GB4743@infradead.org>
References: <1496241195-217678-1-git-send-email-john.garry@huawei.com>
 <1496241195-217678-15-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1496241195-217678-15-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

> +	case SAS_PROTOCOL_SSP:
> +	{
> +		unsigned char op = task->ssp_task.cmd->cmnd[0];
> +
> +		if (op == READ_6 || op == WRITE_6 ||
> +			op == READ_10 || op == WRITE_10 ||
> +			op == READ_12 || op == WRITE_12 ||
> +			op == READ_16 || op == WRITE_16)
> +			return true;
> +		break;
> +	}

Wee. why do you care?  What about 32-byte CDs or things like Write Same?
