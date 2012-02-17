From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 0/4] target/tcm_qla2xxx: Add TMR_ABORT_TASK support
Date: Thu, 16 Feb 2012 17:35:23 -0800
Message-ID: <4F3DAEDB.1070904@redhat.com>
References: <1329133347-13359-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1329133347-13359-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, Madhuranath Iyengar <mni@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

On 02/13/2012 03:42 AM, Nicholas A. Bellinger wrote:
> The following series adds explict TMR_ABORT_TASK support using session
> command list descriptors for target_submit_cmd() fabric module users.

<snip>

> The code can use some more testing and review, but so far these changes
> with simulated I/O delays are generating SAM_STAT_TASK_ABORTED status for
> the aborted tag, or failing with TMR_TASK_DOES_NOT_EXIST as expected..
> 
> Please have a look,

Reviewed, looks good.

Do you have plans to implement ABORT_TASK_SET as well?

Regards -- Andy
