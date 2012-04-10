From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 19/26] [SCSI] qla2xxx: Remove redundant NULL check before
 release_firmware() call.
Date: Tue, 10 Apr 2012 08:22:29 -0400
Message-ID: <alpine.WNT.2.00.1204100821500.5072@N5102REMCQXM4BS.qlogic.org>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net> <alpine.LNX.2.00.1204092229370.13925@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1204092229370.13925@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "trivial@kernel.org" <trivial@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
List-Id: linux-scsi@vger.kernel.org



On Mon, 9 Apr 2012, Jesper Juhl wrote:

> release_firmware() checks for NULL pointers internally so checking
> before calling it is redundant.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
> drivers/scsi/qla2xxx/qla_os.c |    3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index a2f9992..91b6fe6 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4106,8 +4106,7 @@ qla2x00_release_firmware(void)
>
>       mutex_lock(&qla_fw_lock);
>       for (idx = 0; idx < FW_BLOBS; idx++)
> -             if (qla_fw_blobs[idx].fw)
> -                     release_firmware(qla_fw_blobs[idx].fw);
> +             release_firmware(qla_fw_blobs[idx].fw);
>       mutex_unlock(&qla_fw_lock);
> }
>
>

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
