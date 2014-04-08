From: DaeSeok Youn <daeseok.youn@gmail.com>
Subject: Re: [PATCH] [SCSI] be2iscsi: use NULL instead of 0 for pointer
Date: Tue, 8 Apr 2014 10:09:55 +0900
Message-ID: <CAHb8M2CaXisd1k=i6ZFQZ8kYGhxs5TA6UmXS=L7W8zT_E5M-iw@mail.gmail.com>
References: <8505576.9F9pTSfgP9@daeseok-laptop.cloud.net>
	<37724B2049F71D4C9B086F99DDB2DE112A8F09E3@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <37724B2049F71D4C9B086F99DDB2DE112A8F09E3@CMEXMB1.ad.emulex.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "JBottomley@parallels.com" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

This patch didn't apply. Please check for me.
Thanks.
Daeseok Youn

2014-03-12 2:02 GMT+09:00 Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>:
>
>
> -----Original Message-----
> From: Daeseok Youn [mailto:daeseok.youn@gmail.com]
> Sent: Thursday, February 20, 2014 5:13 PM
> To: JBottomley@parallels.com
> Cc: Jayamohan Kallickal; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] [SCSI] be2iscsi: use NULL instead of 0 for pointer
>
> From b483ef302f7d77c586949ae170754d589e8a4935 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Fri, 21 Feb 2014 08:39:08 +0900
> Subject: [PATCH] [SCSI] be2iscsi: use NULL instead of 0 for pointer
>
> sparse says:
>
> drivers/scsi/be2iscsi/be_cmds.c:27:32: warning:
>  Using plain integer as NULL pointer
> drivers/scsi/be2iscsi/be_cmds.c:28:34: warning:
>  Using plain integer as NULL pointer
> drivers/scsi/be2iscsi/be_cmds.c:29:34: warning:
>  Using plain integer as NULL pointer
>
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/scsi/be2iscsi/be_cmds.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c index 3338391..1ec9793 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -24,9 +24,9 @@
>  int beiscsi_pci_soft_reset(struct beiscsi_hba *phba)  {
>         u32 sreset;
> -       u8 *pci_reset_offset = 0;
> -       u8 *pci_online0_offset = 0;
> -       u8 *pci_online1_offset = 0;
> +       u8 *pci_reset_offset = NULL;
> +       u8 *pci_online0_offset = NULL;
> +       u8 *pci_online1_offset = NULL;
>         u32 pconline0 = 0;
>         u32 pconline1 = 0;
>         u32 i;
> --
> 1.7.9.5
>
> Acked-By: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
>
> --
