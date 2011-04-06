From: "helight.xu" <helight.xu@gmail.com>
Subject: =?windows-1252?Q?Re=3A_=5BPATCH=5D_fix_warning=3A_unused?=
 =?windows-1252?Q?_variable_=91log=5Finfo=92_drivers/message/fusion?=
 =?windows-1252?Q?/mptsas=2Ec?=
Date: Wed, 06 Apr 2011 19:29:25 +0800
Message-ID: <4D9C4E95.4070705@gmail.com>
References: <4D9C4E04.9070205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D9C4E04.9070205@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric.Moore <Eric.Moore@lsi.com>; support <support@lsi.com>;
	DL-MPTFusionLinux <DL-MPTFusionLinux@lsi.com>; linux-scsi" <linux-scsi@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/06/2011 07:27 PM, helight.xu wrote:
> fix warning: unused variable =91log_info=92 drivers/message/fusion/mp=
tsas.c
>
>
> Signed-off-by: helight <helight@zhwen.org>
> ---
>  drivers/gpu/drm/nouveau/nv50_vm.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/nv50_vm.c=20
> b/drivers/gpu/drm/nouveau/nv50_vm.c
> index 6144156..1f47c75 100644
> --- a/drivers/gpu/drm/nouveau/nv50_vm.c
> +++ b/drivers/gpu/drm/nouveau/nv50_vm.c
> @@ -31,7 +31,6 @@ void
>  nv50_vm_map_pgt(struct nouveau_gpuobj *pgd, u32 pde,
>          struct nouveau_gpuobj *pgt[2])
>  {
> -    struct drm_nouveau_private *dev_priv =3D pgd->dev->dev_private;
>      u64 phys =3D 0xdeadcafe00000000ULL;
>      u32 coverage =3D 0;
>
sorry ,this is the patch


fix warning: unused variable =91log_info=92 drivers/message/fusion/mpts=
as.c

Signed-off-by: helight <helight@zhwen.org>
---
  drivers/message/fusion/mptsas.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c=20
b/drivers/message/fusion/mptsas.c
index 8aefb18..431092b 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5009,13 +5009,13 @@ mptsas_event_process(MPT_ADAPTER *ioc,=20
EventNotificationReply_t *reply)
              (ioc_stat & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)) {
              VirtTarget *vtarget =3D NULL;
              u8        id, channel;
-            u32     log_info =3D le32_to_cpu(reply->IOCLogInfo);

              id =3D sas_event_data->TargetID;
              channel =3D sas_event_data->Bus;

              vtarget =3D mptsas_find_vtarget(ioc, channel, id);
              if (vtarget) {
+                u32 log_info =3D le32_to_cpu(reply->IOCLogInfo);
                  devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
                      "LogInfo (0x%x) available for "
                     "INTERNAL_DEVICE_RESET"
--=20
1.6.0.2
