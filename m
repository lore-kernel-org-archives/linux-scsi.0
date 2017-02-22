From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 2/3] cciss: Fix checkpatch OPEN_BRACE
Date: Wed, 22 Feb 2017 15:17:36 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D194F3224B5@avsrvexchmbx1.microsemi.net>
References: <1487743958-4208-1-git-send-email-me@tobin.cc>
 <1487743958-4208-3-git-send-email-me@tobin.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1487743958-4208-3-git-send-email-me@tobin.cc>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
To: "Tobin C. Harding" <me@tobin.cc>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Tobin C. Harding [mailto:me@tobin.cc]
> Sent: Wednesday, February 22, 2017 12:13 AM
> To: Don Brace <don.brace@microsemi.com>
> Cc: linux-scsi@vger.kernel.org; kernel-janitors@vger.kernel.org; Tobin C.
> Harding <me@tobin.cc>
> Subject: [PATCH 2/3] cciss: Fix checkpatch OPEN_BRACE
>=20
> EXTERNAL EMAIL
>=20
>=20
> Checkpatch emits ERROR:OPEN_BRACE: that open brace { should be on the
> previous line.
>=20
> Move open brace to new line. Also add space after if/switch statement
> since we introduce more checkpatch errors if not fixed at the same
> time.
>=20
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
Acked-by: Don Brace <don.brace@microsemi.com>
> ---
>  drivers/block/cciss_scsi.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
> index 2b8cfd4..f5c21f3 100644
> --- a/drivers/block/cciss_scsi.c
> +++ b/drivers/block/cciss_scsi.c
> @@ -699,10 +699,8 @@ static void
> complete_scsi_command(CommandList_struct *c, int timeout,
>                         ei->SenseLen);
>         scsi_set_resid(cmd, ei->ResidualCnt);
>=20
> -       if(ei->CommandStatus !=3D 0)
> -       { /* an error has occurred */
> -               switch(ei->CommandStatus)
> -               {
> +       if (ei->CommandStatus !=3D 0) { /* an error has occurred */
> +               switch (ei->CommandStatus) {
>                         case CMD_TARGET_STATUS:
>                                 /* Pass it up to the upper layers... */
>                                 if (!ei->ScsiStatus) {
> @@ -902,8 +900,7 @@ cciss_scsi_interpret_error(ctlr_info_t *h,
> CommandList_struct *c)
>         ErrorInfo_struct *ei;
>=20
>         ei =3D c->err_info;
> -       switch(ei->CommandStatus)
> -       {
> +       switch (ei->CommandStatus) {
>                 case CMD_TARGET_STATUS:
>                         dev_warn(&h->pdev->dev,
>                                 "cmd %p has completed with errors\n", c);
> @@ -1182,8 +1179,7 @@ cciss_update_non_disk_devices(ctlr_info_t *h, int
> hostno)
>                 cciss_scsi_get_device_id(h, scsi3addr,
>                         this_device->device_id, sizeof(this_device->devic=
e_id));
>=20
> -               switch (this_device->devtype)
> -               {
> +               switch (this_device->devtype) {
>                   case 0x05: /* CD-ROM */ {
>=20
>                         /* We don't *really* support actual CD-ROM device=
s,
> @@ -1414,8 +1410,7 @@ cciss_scsi_queue_command_lck(struct scsi_cmnd
> *cmd, void (*done)(struct scsi_cmn
>         memcpy(c->Request.CDB, cmd->cmnd, cmd->cmd_len);
>         c->Request.Type.Type =3D TYPE_CMD;
>         c->Request.Type.Attribute =3D ATTR_SIMPLE;
> -       switch(cmd->sc_data_direction)
> -       {
> +       switch (cmd->sc_data_direction) {
>           case DMA_TO_DEVICE:
>                 c->Request.Type.Direction =3D XFER_WRITE;
>                 break;
> --
> 2.7.4

