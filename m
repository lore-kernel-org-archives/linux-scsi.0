From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Thu, 26 Jun 2014 16:53:54 +0200
Message-ID: <53AC3402.2080302@acm.org>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1402477799-24610-2-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, michaelc@cs.wisc.edu, martin.petersen@oracle.com, nab@linux-iscsi.org, roland@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/11/14 11:09, Sagi Grimberg wrote:
> +	return xfer_len + (xfer_len >> ilog2(sector_size)) * 8;

Sorry that I just noticed this now, but why is a shift-right and ilog2()
used in the above expression instead of just dividing the transfer
length by the sector size ?

Thanks,

Bart.
