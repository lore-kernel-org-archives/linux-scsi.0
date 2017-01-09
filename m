From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/11] qla2xxx: Make trace flags more readable.
Date: Mon, 9 Jan 2017 05:11:49 -0800
Message-ID: <20170109131149.GA4438@infradead.org>
References: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
 <1482553419-4117-4-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1482553419-4117-4-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 23, 2016 at 08:23:31PM -0800, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> This patch does not change any functionality.

...
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -3294,7 +3294,6 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
>  		return EIO;
>  	}
>  	cmd->aborted = 1;
> -	cmd->cmd_flags |= BIT_6;

This seems to be a change in behavior.
