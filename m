From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 11/16] qla2xxx: Add selective command queuing
Date: Wed, 30 Dec 2015 02:27:17 -0800
Message-ID: <20151230102717.GA23966@infradead.org>
References: <1450382231-4259-1-git-send-email-himanshu.madhani@qlogic.com>
 <1450382231-4259-12-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1450382231-4259-12-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>  drivers/scsi/qla2xxx/qla_isr.c         |    2 +-
>  drivers/scsi/qla2xxx/qla_target.c      |   13 ++++++++++++-
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    4 ++--
>  drivers/target/target_core_transport.c |    5 ++++-
>  include/target/target_core_base.h      |    1 +

please split out target core changes from your drivers bits into a
separate patch!

>  	cmd->cmd_in_wq = 1;
>  	cmd->cmd_flags |= BIT_0;
> +	cmd->se_cmd.cpuid = -1;

As Bart pointed out please use the proper constants.  Also make
sure this is initialized in the core target code instad of here.
