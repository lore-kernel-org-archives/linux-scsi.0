From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: bnx2fc: Check if sense buffer has been allocated during completion
Date: Thu, 20 Jun 2019 16:50:53 -0400
Message-ID: <yq1v9x0q8uq.fsf@oracle.com>
References: <1560501397-831-1-git-send-email-92siuyang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1560501397-831-1-git-send-email-92siuyang@gmail.com> (Young
        Xiao's message of "Fri, 14 Jun 2019 16:36:37 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Young Xiao <92siuyang@gmail.com>
Cc: QLogic-Storage-Upstream@qlogic.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi Young,

> sc_cmd->sense_buffer is not guaranteed to be allocated so we need to
> sc_cmd->check if the pointer is NULL before trying to copy anything
> into it.

bnx2fc does not appear to use a driver-specific sense buffer.

-- 
Martin K. Petersen	Oracle Linux Engineering
