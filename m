From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: [PATCH linux/linux-next] mpt2sas:
 _scsih_sas_broadcast_primitive_event: Quiet unused variable warning
Date: Tue, 26 Feb 2013 17:48:13 +0530
Message-ID: <DCD177647606E9419ED923E0C8C4AA7223E77C8E99@inbmail02.lsi.com>
References: <1361386107-49136-1-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1361386107-49136-1-git-send-email-tim.gardner@canonical.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tim Gardner <tim.gardner@canonical.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, Support <support@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Tim,

Today I have sent the below titled patch to upstream which fix the "Unused variable 'event_data' warning".
 The Patch title is 
	"[PATCH][SCSI] mpt2sas: fix for unused variable 'event_data' warning"

This patch will help you in fixing the "Unused variable 'event_data' warning".

Thanks,
Sreekanth

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Tim Gardner
> Sent: Thursday, February 21, 2013 12:18 AM
> To: linux-kernel@vger.kernel.org
> Cc: Tim Gardner; Nandigama, Nagalakshmi; Reddy, Sreekanth; Support;
> James E.J. Bottomley; DL-MPT Fusion Linux; linux-scsi@vger.kernel.org
> Subject: [PATCH linux/linux-next] mpt2sas:
> _scsih_sas_broadcast_primitive_event: Quiet unused variable warning
> 
> If CONFIG_SCSI_MPT2SAS_LOGGING is undefined, then these warnings are
> emitted:
> 
> drivers/scsi/mpt2sas/mpt2sas_scsih.c: In function
> '_scsih_sas_broadcast_primitive_event':
> drivers/scsi/mpt2sas/mpt2sas_scsih.c:5810:40: warning: unused variable
> 'event_data' [-Wunused-variable]
> 
> Add __maybe_unused to the definition of event_data.
> 
> Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
> Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> Cc: support@lsi.com
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: DL-MPTFusionLinux@lsi.com
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index c6bdc92..416f907 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -5807,7 +5807,8 @@ _scsih_sas_broadcast_primitive_event(struct
> MPT2SAS_ADAPTER *ioc,
>  	u32 termination_count;
>  	u32 query_count;
>  	Mpi2SCSITaskManagementReply_t *mpi_reply;
> -	Mpi2EventDataSasBroadcastPrimitive_t *event_data = fw_event-
> >event_data;
> +	Mpi2EventDataSasBroadcastPrimitive_t *event_data
> __maybe_unused =
> +		fw_event->event_data;
>  	u16 ioc_status;
>  	unsigned long flags;
>  	int r;
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
