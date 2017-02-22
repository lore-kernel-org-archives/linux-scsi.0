From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 1/3] cciss: Fix checkpatch TRAILING_WHITESPACE
Date: Wed, 22 Feb 2017 15:20:00 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D194F3224DC@avsrvexchmbx1.microsemi.net>
References: <1487743958-4208-1-git-send-email-me@tobin.cc>
 <1487743958-4208-2-git-send-email-me@tobin.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1487743958-4208-2-git-send-email-me@tobin.cc>
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
> Subject: [PATCH 1/3] cciss: Fix checkpatch TRAILING_WHITESPACE
>=20
> EXTERNAL EMAIL
>=20
>=20
> Checkpatch emits 85 trailing whitespace warnings.
>=20
> Remove trailing whitespace.
>=20
> Signed-off-by: Tobin C. Harding <me@tobin.cc>

Acked-by: Don Brace <don.brace@microsemi.com>

> ---
>  drivers/block/cciss_scsi.c | 170 ++++++++++++++++++++++-----------------=
---
> ---
>  1 file changed, 85 insertions(+), 85 deletions(-)
>=20
> diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
> index a18de9d..2b8cfd4 100644
> --- a/drivers/block/cciss_scsi.c
> +++ b/drivers/block/cciss_scsi.c
> @@ -17,15 +17,15 @@
>   *    02111-1307, USA.
>   *
>   *    Questions/Comments/Bugfixes to iss_storagedev@hp.com
> - *
> + *
>   *    Author: Stephen M. Cameron
>   */
>  #ifdef CONFIG_CISS_SCSI_TAPE
>=20
> -/* Here we have code to present the driver as a scsi driver
> -   as it is simultaneously presented as a block driver.  The
> +/* Here we have code to present the driver as a scsi driver
> +   as it is simultaneously presented as a block driver.  The
>     reason for doing this is to allow access to SCSI tape drives
> -   through the array controller.  Note in particular, neither
> +   through the array controller.  Note in particular, neither
>     physical nor logical disks are presented through the scsi layer. */
>=20
>  #include <linux/timer.h>
> @@ -37,7 +37,7 @@
>=20
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_device.h>
> -#include <scsi/scsi_host.h>
> +#include <scsi/scsi_host.h>
>=20
>  #include "cciss_scsi.h"
>=20
> @@ -120,7 +120,7 @@ struct cciss_scsi_adapter_data_t {
>         struct cciss_scsi_cmd_stack_t cmd_stack;
>         SGDescriptor_struct **cmd_sg_list;
>         int registered;
> -       spinlock_t lock; // to protect ccissscsi[ctlr];
> +       spinlock_t lock; // to protect ccissscsi[ctlr];
>  };
>=20
>  #define CPQ_TAPE_LOCK(h, flags) spin_lock_irqsave( \
> @@ -143,36 +143,36 @@ scsi_cmd_alloc(ctlr_info_t *h)
>         u64bit temp64;
>=20
>         sa =3D h->scsi_ctlr;
> -       stk =3D &sa->cmd_stack;
> +       stk =3D &sa->cmd_stack;
>=20
> -       if (stk->top < 0)
> +       if (stk->top < 0)
>                 return NULL;
> -       c =3D stk->elem[stk->top];
> +       c =3D stk->elem[stk->top];
>         /* memset(c, 0, sizeof(*c)); */
>         memset(&c->cmd, 0, sizeof(c->cmd));
>         memset(&c->Err, 0, sizeof(c->Err));
>         /* set physical addr of cmd and addr of scsi parameters */
> -       c->cmd.busaddr =3D c->busaddr;
> +       c->cmd.busaddr =3D c->busaddr;
>         c->cmd.cmdindex =3D c->cmdindex;
> -       /* (__u32) (stk->cmd_pool_handle +
> +       /* (__u32) (stk->cmd_pool_handle +
>                 (sizeof(struct cciss_scsi_cmd_stack_elem_t)*stk->top)); *=
/
>=20
>         temp64.val =3D (__u64) (c->busaddr + sizeof(CommandList_struct));
> -       /* (__u64) (stk->cmd_pool_handle +
> +       /* (__u64) (stk->cmd_pool_handle +
>                 (sizeof(struct cciss_scsi_cmd_stack_elem_t)*stk->top) +
>                  sizeof(CommandList_struct)); */
>         stk->top--;
>         c->cmd.ErrDesc.Addr.lower =3D temp64.val32.lower;
>         c->cmd.ErrDesc.Addr.upper =3D temp64.val32.upper;
>         c->cmd.ErrDesc.Len =3D sizeof(ErrorInfo_struct);
> -
> +
>         c->cmd.ctlr =3D h->ctlr;
>         c->cmd.err_info =3D &c->Err;
>=20
>         return (CommandList_struct *) c;
>  }
>=20
> -static void
> +static void
>  scsi_cmd_free(ctlr_info_t *h, CommandList_struct *c)
>  {
>         /* assume only one process in here at a time, locking done by cal=
ler. */
> @@ -183,7 +183,7 @@ scsi_cmd_free(ctlr_info_t *h, CommandList_struct
> *c)
>         struct cciss_scsi_cmd_stack_t *stk;
>=20
>         sa =3D h->scsi_ctlr;
> -       stk =3D &sa->cmd_stack;
> +       stk =3D &sa->cmd_stack;
>         stk->top++;
>         if (stk->top >=3D stk->nelems) {
>                 dev_err(&h->pdev->dev,
> @@ -228,7 +228,7 @@ scsi_cmd_stack_setup(ctlr_info_t *h, struct
> cciss_scsi_adapter_data_t *sa)
>         }
>         for (i =3D 0; i < stk->nelems; i++) {
>                 stk->elem[i] =3D &stk->pool[i];
> -               stk->elem[i]->busaddr =3D (__u32) (stk->cmd_pool_handle +
> +               stk->elem[i]->busaddr =3D (__u32) (stk->cmd_pool_handle +
>                         (sizeof(struct cciss_scsi_cmd_stack_elem_t) * i))=
;
>                 stk->elem[i]->cmdindex =3D i;
>         }
> @@ -244,7 +244,7 @@ scsi_cmd_stack_free(ctlr_info_t *h)
>         size_t size;
>=20
>         sa =3D h->scsi_ctlr;
> -       stk =3D &sa->cmd_stack;
> +       stk =3D &sa->cmd_stack;
>         if (stk->top !=3D stk->nelems-1) {
>                 dev_warn(&h->pdev->dev,
>                         "bug: %d scsi commands are still outstanding.\n",
> @@ -266,7 +266,7 @@ print_cmd(CommandList_struct *cp)
>         printk("queue:%d\n", cp->Header.ReplyQueue);
>         printk("sglist:%d\n", cp->Header.SGList);
>         printk("sgtot:%d\n", cp->Header.SGTotal);
> -       printk("Tag:0x%08x/0x%08x\n", cp->Header.Tag.upper,
> +       printk("Tag:0x%08x/0x%08x\n", cp->Header.Tag.upper,
>                         cp->Header.Tag.lower);
>         printk("LUN:0x%8phN\n", cp->Header.LUN.LunAddrBytes);
>         printk("CDBLen:%d\n", cp->Request.CDBLen);
> @@ -275,8 +275,8 @@ print_cmd(CommandList_struct *cp)
>         printk(" Dir:%d\n",cp->Request.Type.Direction);
>         printk("Timeout:%d\n",cp->Request.Timeout);
>         printk("CDB: %16ph\n", cp->Request.CDB);
> -       printk("edesc.Addr: 0x%08x/0%08x, Len  =3D %d\n",
> -               cp->ErrDesc.Addr.upper, cp->ErrDesc.Addr.lower,
> +       printk("edesc.Addr: 0x%08x/0%08x, Len  =3D %d\n",
> +               cp->ErrDesc.Addr.upper, cp->ErrDesc.Addr.lower,
>                         cp->ErrDesc.Len);
>         printk("sgs..........Errorinfo:\n");
>         printk("scsistatus:%d\n", cp->err_info->ScsiStatus);
> @@ -289,7 +289,7 @@ print_cmd(CommandList_struct *cp)
>  }
>  #endif
>=20
> -static int
> +static int
>  find_bus_target_lun(ctlr_info_t *h, int *bus, int *target, int *lun)
>  {
>         /* finds an unused bus, target, lun for a new device */
> @@ -299,24 +299,24 @@ find_bus_target_lun(ctlr_info_t *h, int *bus, int
> *target, int *lun)
>=20
>         memset(&target_taken[0], 0, CCISS_MAX_SCSI_DEVS_PER_HBA);
>=20
> -       target_taken[SELF_SCSI_ID] =3D 1;
> +       target_taken[SELF_SCSI_ID] =3D 1;
>         for (i =3D 0; i < ccissscsi[h->ctlr].ndevices; i++)
>                 target_taken[ccissscsi[h->ctlr].dev[i].target] =3D 1;
> -
> +
>         for (i =3D 0; i < CCISS_MAX_SCSI_DEVS_PER_HBA; i++) {
>                 if (!target_taken[i]) {
>                         *bus =3D 0; *target=3Di; *lun =3D 0; found=3D1;
>                         break;
>                 }
>         }
> -       return (!found);
> +       return (!found);
>  }
>  struct scsi2map {
>         char scsi3addr[8];
>         int bus, target, lun;
>  };
>=20
> -static int
> +static int
>  cciss_scsi_add_entry(ctlr_info_t *h, int hostno,
>                 struct cciss_scsi_dev_t *device,
>                 struct scsi2map *added, int *nadded)
> @@ -381,8 +381,8 @@ cciss_scsi_add_entry(ctlr_info_t *h, int hostno,
>=20
>         ccissscsi[h->ctlr].ndevices++;
>=20
> -       /* initially, (before registering with scsi layer) we don't
> -          know our hostno and we don't want to print anything first
> +       /* initially, (before registering with scsi layer) we don't
> +          know our hostno and we don't want to print anything first
>            time anyway (the scsi layer's inquiries will show that info) *=
/
>         if (hostno !=3D -1)
>                 dev_info(&h->pdev->dev, "%s device c%db%dt%dl%d added.\n"=
,
> @@ -467,7 +467,7 @@ adjust_cciss_scsi_table(ctlr_info_t *h, int hostno,
>         /* sd contains scsi3 addresses and devtypes, but
>            bus target and lun are not filled in.  This funciton
>            takes what's in sd to be the current and adjusts
> -          ccissscsi[] to be in line with what's in sd. */
> +          ccissscsi[] to be in line with what's in sd. */
>=20
>         int i,j, found, changes=3D0;
>         struct cciss_scsi_dev_t *csd;
> @@ -492,7 +492,7 @@ adjust_cciss_scsi_table(ctlr_info_t *h, int hostno,
>         if (hostno !=3D -1)  /* if it's not the first time... */
>                 sh =3D h->scsi_ctlr->scsi_host;
>=20
> -       /* find any devices in ccissscsi[] that are not in
> +       /* find any devices in ccissscsi[] that are not in
>            sd[] and remove them from ccissscsi[] */
>=20
>         i =3D 0;
> @@ -512,7 +512,7 @@ adjust_cciss_scsi_table(ctlr_info_t *h, int hostno,
>                         }
>                 }
>=20
> -               if (found =3D=3D 0) { /* device no longer present. */
> +               if (found =3D=3D 0) { /* device no longer present. */
>                         changes++;
>                         cciss_scsi_remove_entry(h, hostno, i,
>                                 removed, &nremoved);
> @@ -641,14 +641,14 @@ lookup_scsi3addr(ctlr_info_t *h, int bus, int targe=
t,
> int lun, char *scsi3addr)
>         return -1;
>  }
>=20
> -static void
> +static void
>  cciss_scsi_setup(ctlr_info_t *h)
>  {
>         struct cciss_scsi_adapter_data_t * shba;
>=20
>         ccissscsi[h->ctlr].ndevices =3D 0;
>         shba =3D (struct cciss_scsi_adapter_data_t *)
> -               kmalloc(sizeof(*shba), GFP_KERNEL);
> +               kmalloc(sizeof(*shba), GFP_KERNEL);
>         if (shba =3D=3D NULL)
>                 return;
>         shba->scsi_host =3D NULL;
> @@ -693,20 +693,20 @@ static void
> complete_scsi_command(CommandList_struct *c, int timeout,
>=20
>         /* copy the sense data whether we need to or not. */
>=20
> -       memcpy(cmd->sense_buffer, ei->SenseInfo,
> +       memcpy(cmd->sense_buffer, ei->SenseInfo,
>                 ei->SenseLen > SCSI_SENSE_BUFFERSIZE ?
> -                       SCSI_SENSE_BUFFERSIZE :
> +                       SCSI_SENSE_BUFFERSIZE :
>                         ei->SenseLen);
>         scsi_set_resid(cmd, ei->ResidualCnt);
>=20
> -       if(ei->CommandStatus !=3D 0)
> -       { /* an error has occurred */
> +       if(ei->CommandStatus !=3D 0)
> +       { /* an error has occurred */
>                 switch(ei->CommandStatus)
>                 {
>                         case CMD_TARGET_STATUS:
>                                 /* Pass it up to the upper layers... */
>                                 if (!ei->ScsiStatus) {
> -
> +
>         /* Ordinarily, this case should never happen, but there is a bug
>            in some released firmware revisions that allows it to happen
>            if, for example, a 4100 backplane loses power and the tape
> @@ -731,7 +731,7 @@ static void
> complete_scsi_command(CommandList_struct *c, int timeout,
>                                 print_cmd(c);
>                                  */
>       /* We get CMD_INVALID if you address a non-existent tape drive inst=
ead
> -       of a selection timeout (no response).  You will see this if you y=
ank
> +       of a selection timeout (no response).  You will see this if you y=
ank
>         out a tape drive, then try to access it. This is kind of a shame
>         because it means that any other CMD_INVALID (e.g. driver bug) wil=
l
>         get interpreted as a missing target. */
> @@ -780,7 +780,7 @@ static void
> complete_scsi_command(CommandList_struct *c, int timeout,
>                                 cmd->result =3D DID_ERROR << 16;
>                                 dev_warn(&h->pdev->dev,
>                                         "%p returned unknown status %x\n"=
, c,
> -                                               ei->CommandStatus);
> +                                               ei->CommandStatus);
>                 }
>         }
>         cmd->scsi_done(cmd);
> @@ -796,15 +796,15 @@ cciss_scsi_detect(ctlr_info_t *h)
>         sh =3D scsi_host_alloc(&cciss_driver_template, sizeof(struct ctlr=
_info *));
>         if (sh =3D=3D NULL)
>                 goto fail;
> -       sh->io_port =3D 0;        // good enough?  FIXME,
> +       sh->io_port =3D 0;        // good enough?  FIXME,
>         sh->n_io_port =3D 0;      // I don't think we use these two...
> -       sh->this_id =3D SELF_SCSI_ID;
> +       sh->this_id =3D SELF_SCSI_ID;
>         sh->can_queue =3D cciss_tape_cmds;
>         sh->sg_tablesize =3D h->maxsgentries;
>         sh->max_cmd_len =3D MAX_COMMAND_SIZE;
>         sh->max_sectors =3D h->cciss_max_sectors;
>=20
> -       ((struct cciss_scsi_adapter_data_t *)
> +       ((struct cciss_scsi_adapter_data_t *)
>                 h->scsi_ctlr)->scsi_host =3D sh;
>         sh->hostdata[0] =3D (unsigned long) h;
>         sh->irq =3D h->intr[SIMPLE_MODE_INT];
> @@ -856,7 +856,7 @@ cciss_map_one(struct pci_dev *pdev,
>  static int
>  cciss_scsi_do_simple_cmd(ctlr_info_t *h,
>                         CommandList_struct *c,
> -                       unsigned char *scsi3addr,
> +                       unsigned char *scsi3addr,
>                         unsigned char *cdb,
>                         unsigned char cdblen,
>                         unsigned char *buf, int bufsize,
> @@ -871,7 +871,7 @@ cciss_scsi_do_simple_cmd(ctlr_info_t *h,
>         c->Header.Tag.lower =3D c->busaddr;  /* Use k. address of cmd as =
tag */
>         // Fill in the request block...
>=20
> -       /* printk("Using scsi3addr
> 0x%02x%0x2%0x2%0x2%0x2%0x2%0x2%0x2\n",
> +       /* printk("Using scsi3addr
> 0x%02x%0x2%0x2%0x2%0x2%0x2%0x2%0x2\n",
>                 scsi3addr[0], scsi3addr[1], scsi3addr[2], scsi3addr[3],
>                 scsi3addr[4], scsi3addr[5], scsi3addr[6], scsi3addr[7]); =
*/
>=20
> @@ -885,7 +885,7 @@ cciss_scsi_do_simple_cmd(ctlr_info_t *h,
>=20
>         /* Fill in the SG list and do dma mapping */
>         cciss_map_one(h->pdev, c, (unsigned char *) buf,
> -                       bufsize, DMA_FROM_DEVICE);
> +                       bufsize, DMA_FROM_DEVICE);
>=20
>         c->waiting =3D &wait;
>         enqueue_cmd_and_start_io(h, c);
> @@ -896,7 +896,7 @@ cciss_scsi_do_simple_cmd(ctlr_info_t *h,
>         return(0);
>  }
>=20
> -static void
> +static void
>  cciss_scsi_interpret_error(ctlr_info_t *h, CommandList_struct *c)
>  {
>         ErrorInfo_struct *ei;
> @@ -1005,7 +1005,7 @@ cciss_scsi_do_inquiry(ctlr_info_t *h, unsigned char
> *scsi3addr,
>=20
>         if (rc !=3D 0) return rc; /* something went wrong */
>=20
> -       if (ei->CommandStatus !=3D 0 &&
> +       if (ei->CommandStatus !=3D 0 &&
>             ei->CommandStatus !=3D CMD_DATA_UNDERRUN) {
>                 cciss_scsi_interpret_error(h, c);
>                 rc =3D -1;
> @@ -1013,7 +1013,7 @@ cciss_scsi_do_inquiry(ctlr_info_t *h, unsigned char
> *scsi3addr,
>         spin_lock_irqsave(&h->lock, flags);
>         scsi_cmd_free(h, c);
>         spin_unlock_irqrestore(&h->lock, flags);
> -       return rc;
> +       return rc;
>  }
>=20
>  /* Get the device id from inquiry page 0x83 */
> @@ -1042,7 +1042,7 @@ cciss_scsi_do_report_phys_luns(ctlr_info_t *h,
>         int rc;
>         CommandList_struct *c;
>         unsigned char cdb[12];
> -       unsigned char scsi3addr[8];
> +       unsigned char scsi3addr[8];
>         ErrorInfo_struct *ei;
>         unsigned long flags;
>=20
> @@ -1069,14 +1069,14 @@ cciss_scsi_do_report_phys_luns(ctlr_info_t *h,
>         cdb[11] =3D 0;
>=20
>         rc =3D cciss_scsi_do_simple_cmd(h, c, scsi3addr,
> -                               cdb, 12,
> -                               (unsigned char *) buf,
> +                               cdb, 12,
> +                               (unsigned char *) buf,
>                                 bufsize, XFER_READ);
>=20
>         if (rc !=3D 0) return rc; /* something went wrong */
>=20
>         ei =3D c->err_info;
> -       if (ei->CommandStatus !=3D 0 &&
> +       if (ei->CommandStatus !=3D 0 &&
>             ei->CommandStatus !=3D CMD_DATA_UNDERRUN) {
>                 cciss_scsi_interpret_error(h, c);
>                 rc =3D -1;
> @@ -1084,36 +1084,36 @@ cciss_scsi_do_report_phys_luns(ctlr_info_t *h,
>         spin_lock_irqsave(&h->lock, flags);
>         scsi_cmd_free(h, c);
>         spin_unlock_irqrestore(&h->lock, flags);
> -       return rc;
> +       return rc;
>  }
>=20
>  static void
>  cciss_update_non_disk_devices(ctlr_info_t *h, int hostno)
>  {
>         /* the idea here is we could get notified from /proc
> -          that some devices have changed, so we do a report
> -          physical luns cmd, and adjust our list of devices
> +          that some devices have changed, so we do a report
> +          physical luns cmd, and adjust our list of devices
>            accordingly.  (We can't rely on the scsi-mid layer just
> -          doing inquiries, because the "busses" that the scsi
> +          doing inquiries, because the "busses" that the scsi
>            mid-layer probes are totally fabricated by this driver,
>            so new devices wouldn't show up.
>=20
> -          the scsi3addr's of devices won't change so long as the
> -          adapter is not reset.  That means we can rescan and
> -          tell which devices we already know about, vs. new
> +          the scsi3addr's of devices won't change so long as the
> +          adapter is not reset.  That means we can rescan and
> +          tell which devices we already know about, vs. new
>            devices, vs.  disappearing devices.
>=20
>            Also, if you yank out a tape drive, then put in a disk
> -          in it's place, (say, a configured volume from another
> -          array controller for instance)  _don't_ poke this driver
> -           (so it thinks it's still a tape, but _do_ poke the scsi
> -           mid layer, so it does an inquiry... the scsi mid layer
> +          in it's place, (say, a configured volume from another
> +          array controller for instance)  _don't_ poke this driver
> +           (so it thinks it's still a tape, but _do_ poke the scsi
> +           mid layer, so it does an inquiry... the scsi mid layer
>             will see the physical disk.  This would be bad.  Need to
> -          think about how to prevent that.  One idea would be to
> +          think about how to prevent that.  One idea would be to
>            snoop all scsi responses and if an inquiry repsonse comes
>            back that reports a disk, chuck it an return selection
>            timeout instead and adjust our table...  Not sure i like
> -          that though.
> +          that though.
>=20
>          */
>  #define OBDR_TAPE_INQ_SIZE 49
> @@ -1141,9 +1141,9 @@ cciss_update_non_disk_devices(ctlr_info_t *h, int
> hostno)
>                 ch =3D &ld_buff->LUNListLength[0];
>                 num_luns =3D ((ch[0]<<24) | (ch[1]<<16) | (ch[2]<<8) | ch=
[3]) / 8;
>                 if (num_luns > CISS_MAX_PHYS_LUN) {
> -                       printk(KERN_WARNING
> +                       printk(KERN_WARNING
>                                 "cciss: Maximum physical LUNs (%d) exceed=
ed.  "
> -                               "%d LUNs ignored.\n", CISS_MAX_PHYS_LUN,
> +                               "%d LUNs ignored.\n", CISS_MAX_PHYS_LUN,
>                                 num_luns - CISS_MAX_PHYS_LUN);
>                         num_luns =3D CISS_MAX_PHYS_LUN;
>                 }
> @@ -1154,7 +1154,7 @@ cciss_update_non_disk_devices(ctlr_info_t *h, int
> hostno)
>         }
>=20
>=20
> -       /* adjust our table of devices */
> +       /* adjust our table of devices */
>         for (i =3D 0; i < num_luns; i++) {
>                 /* for each physical lun, do an inquiry */
>                 if (ld_buff->LUN[i][3] & 0xC0) continue;
> @@ -1213,7 +1213,7 @@ cciss_update_non_disk_devices(ctlr_info_t *h, int
> hostno)
>                         currentsd[ncurrent] =3D *this_device;
>                         ncurrent++;
>                         break;
> -                 default:
> +                 default:
>                         break;
>                 }
>         }
> @@ -1258,8 +1258,8 @@ cciss_scsi_write_info(struct Scsi_Host *sh,
>                 return -EINVAL;
>=20
>         return cciss_scsi_user_command(h, sh->host_no,
> -                       buffer, length);
> -}
> +                       buffer, length);
> +}
>=20
>  static int
>  cciss_scsi_show_info(struct seq_file *m, struct Scsi_Host *sh)
> @@ -1297,8 +1297,8 @@ cciss_scsi_show_info(struct seq_file *m, struct
> Scsi_Host *sh)
>         return 0;
>  }
>=20
> -/* cciss_scatter_gather takes a struct scsi_cmnd, (cmd), and does the pc=
i
> -   dma mapping  and fills in the scatter gather entries of the
> +/* cciss_scatter_gather takes a struct scsi_cmnd, (cmd), and does the pc=
i
> +   dma mapping  and fills in the scatter gather entries of the
>     cciss command, c. */
>=20
>  static void cciss_scatter_gather(ctlr_info_t *h, CommandList_struct *c,
> @@ -1394,7 +1394,7 @@ cciss_scsi_queue_command_lck(struct scsi_cmnd
> *cmd, void (*done)(struct scsi_cmn
>=20
>         // Fill in the command list header
>=20
> -       cmd->scsi_done =3D done;    // save this for use by completion co=
de
> +       cmd->scsi_done =3D done;    // save this for use by completion co=
de
>=20
>         /* save c in case we have to abort it */
>         cmd->host_scribble =3D (unsigned char *) c;
> @@ -1404,7 +1404,7 @@ cciss_scsi_queue_command_lck(struct scsi_cmnd
> *cmd, void (*done)(struct scsi_cmn
>         c->Header.ReplyQueue =3D 0;  /* unused in simple mode */
>         memcpy(&c->Header.LUN.LunAddrBytes[0], &scsi3addr[0], 8);
>         c->Header.Tag.lower =3D c->busaddr;  /* Use k. address of cmd as =
tag */
> -
> +
>         // Fill in the request block...
>=20
>         c->Request.Timeout =3D 0;
> @@ -1432,15 +1432,15 @@ cciss_scsi_queue_command_lck(struct
> scsi_cmnd *cmd, void (*done)(struct scsi_cmn
>=20
>                 c->Request.Type.Direction =3D XFER_RSVD;
>                 // This is technically wrong, and cciss controllers shoul=
d
> -               // reject it with CMD_INVALID, which is the most correct
> -               // response, but non-fibre backends appear to let it
> +               // reject it with CMD_INVALID, which is the most correct
> +               // response, but non-fibre backends appear to let it
>                 // slide by, and give the same results as if this field
>                 // were set correctly.  Either way is acceptable for
>                 // our purposes here.
>=20
>                 break;
>=20
> -         default:
> +         default:
>                 dev_warn(&h->pdev->dev, "unknown data direction: %d\n",
>                         cmd->sc_data_direction);
>                 BUG();
> @@ -1464,9 +1464,9 @@ static void cciss_unregister_scsi(ctlr_info_t *h)
>=20
>         spin_lock_irqsave(&h->lock, flags);
>         sa =3D h->scsi_ctlr;
> -       stk =3D &sa->cmd_stack;
> +       stk =3D &sa->cmd_stack;
>=20
> -       /* if we weren't ever actually registered, don't unregister */
> +       /* if we weren't ever actually registered, don't unregister */
>         if (sa->registered) {
>                 spin_unlock_irqrestore(&h->lock, flags);
>                 scsi_remove_host(sa->scsi_host);
> @@ -1474,7 +1474,7 @@ static void cciss_unregister_scsi(ctlr_info_t *h)
>                 spin_lock_irqsave(&h->lock, flags);
>         }
>=20
> -       /* set scsi_host to NULL so our detect routine will
> +       /* set scsi_host to NULL so our detect routine will
>            find us on register */
>         sa->scsi_host =3D NULL;
>         spin_unlock_irqrestore(&h->lock, flags);
> @@ -1490,7 +1490,7 @@ static int cciss_engage_scsi(ctlr_info_t *h)
>=20
>         spin_lock_irqsave(&h->lock, flags);
>         sa =3D h->scsi_ctlr;
> -       stk =3D &sa->cmd_stack;
> +       stk =3D &sa->cmd_stack;
>=20
>         if (sa->registered) {
>                 dev_info(&h->pdev->dev, "SCSI subsystem already engaged.\=
n");
> @@ -1586,13 +1586,13 @@ static int
> wait_for_device_to_become_ready(ctlr_info_t *h,
>         return rc;
>  }
>=20
> -/* Need at least one of these error handlers to keep ../scsi/hosts.c fro=
m
> - * complaining.  Doing a host- or bus-reset can't do anything good here.
> +/* Need at least one of these error handlers to keep ../scsi/hosts.c fro=
m
> + * complaining.  Doing a host- or bus-reset can't do anything good here.
>   * Despite what it might say in scsi_error.c, there may well be commands
>   * on the controller, as the cciss driver registers twice, once as a blo=
ck
>   * device for the logical drives, and once as a scsi device, for any tap=
e
>   * drives.  So we know there are no commands out on the tape drives, but
> we
> - * don't know there are no commands on the controller, and it is likely
> + * don't know there are no commands on the controller, and it is likely
>   * that there probably are, as the cciss block device is most commonly u=
sed
>   * as a boot device (embedded controller on HP/Compaq systems.)
>  */
> --
> 2.7.4

