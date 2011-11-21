From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH][TRIVIAL] SCSI, qla2xxx: remove redundant semicolon
Date: Mon, 21 Nov 2011 12:38:44 -0500
Message-ID: <alpine.WNT.2.00.1111211237510.5992@N5102REMCQXM4BS.qlogic.org>
References: <alpine.LNX.2.00.1111202231550.17395@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1111202231550.17395@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Driver <Linux-Driver@qlogic.com>, linux-kernel <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "trivial@kernel.org" <trivial@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Makes sense.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

On Sun, 20 Nov 2011, Jesper Juhl wrote:

> One ';' at the end of the return statement is enough.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
> drivers/scsi/qla2xxx/qla_nx.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index 94bded5..b9b3e5a 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -1055,7 +1055,7 @@ ql82xx_rom_lock_d(struct qla_hw_data *ha)
>                   "ROM lock failed.\n");
>               return -1;
>       }
> -     return 0;;
> +     return 0;
> }
>
> static int
>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
