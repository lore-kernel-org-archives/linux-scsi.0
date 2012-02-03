From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH] [trivial] qla2xxx: Fix typo in qla_bsg.c
Date: Fri, 3 Feb 2012 12:36:04 -0500
Message-ID: <alpine.WNT.2.00.1202031234580.2256@N5102REMCQXM4BS.qlogic.org>
References: <1328274925-1809-1-git-send-email-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328274925-1809-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masanari Iida <standby24x7@gmail.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Dept-ENG Linux Driver <Linux-Driver@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "trivial@kernel.org" <trivial@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Looks good. Thanks for the catch.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

On Fri, 3 Feb 2012, Masanari Iida wrote:

> Correct spelling "curent" to "current" in
> drivers/scsi/qla2xxx/qla_bsg.c
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
> drivers/scsi/qla2xxx/qla_bsg.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index b1d0f93..a1c6a16 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -745,7 +745,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
>
>                       if (elreq.options != EXTERNAL_LOOPBACK) {
>                               ql_dbg(ql_dbg_user, vha, 0x7020,
> -                                 "Internal: curent port config = %x\n",
> +                                 "Internal: current port config = %x\n",
>                                   config[0]);
>                               if (qla81xx_set_internal_loopback(vha, config,
>                                       new_config)) {
>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
