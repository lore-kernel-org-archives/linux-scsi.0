From: James Smart <james.smart@avagotech.com>
Subject: Re: [PATCH trivial] lpfc: Grammar s/an negative/a negative/
Date: Thu, 21 May 2015 11:53:40 -0400
Message-ID: <555DFF84.1050604@avagotech.com>
References: <1432210293-22684-1-git-send-email-geert+renesas@glider.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432210293-22684-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert+renesas@glider.be>, "James E.J. Bottomley" <JBottomley@odin.com>, Jiri Kosina <trivial@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Reviewed-By: James Smart <james.smart@avagotech.com>

looks fine.

Thanks

-- james s


On 5/21/2015 8:11 AM, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>   drivers/scsi/lpfc/lpfc_debugfs.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
> index 513edcb0c2dae379..25aa9b98d53aa345 100644
> --- a/drivers/scsi/lpfc/lpfc_debugfs.c
> +++ b/drivers/scsi/lpfc/lpfc_debugfs.c
> @@ -710,7 +710,7 @@ lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, char *fmt,
>    * returns a pointer to that log in the private_data field in @file.
>    *
>    * Returns:
> - * This function returns zero if successful. On error it will return an negative
> + * This function returns zero if successful. On error it will return a negative
>    * error value.
>    **/
>   static int
> @@ -760,7 +760,7 @@ out:
>    * returns a pointer to that log in the private_data field in @file.
>    *
>    * Returns:
> - * This function returns zero if successful. On error it will return an negative
> + * This function returns zero if successful. On error it will return a negative
>    * error value.
>    **/
>   static int
> @@ -810,7 +810,7 @@ out:
>    * returns a pointer to that log in the private_data field in @file.
>    *
>    * Returns:
> - * This function returns zero if successful. On error it will return an negative
> + * This function returns zero if successful. On error it will return a negative
>    * error value.
>    **/
>   static int
> @@ -852,7 +852,7 @@ out:
>    * returns a pointer to that log in the private_data field in @file.
>    *
>    * Returns:
> - * This function returns zero if successful. On error it will return an negative
> + * This function returns zero if successful. On error it will return a negative
>    * error value.
>    **/
>   static int
> @@ -894,7 +894,7 @@ out:
>    * returns a pointer to that log in the private_data field in @file.
>    *
>    * Returns:
> - * This function returns zero if successful. On error it will return an negative
> + * This function returns zero if successful. On error it will return a negative
>    * error value.
>    **/
>   static int
> @@ -1115,7 +1115,7 @@ lpfc_debugfs_dif_err_release(struct inode *inode, struct file *file)
>    * returns a pointer to that log in the private_data field in @file.
>    *
>    * Returns:
> - * This function returns zero if successful. On error it will return an negative
> + * This function returns zero if successful. On error it will return a negative
>    * error value.
>    **/
>   static int
