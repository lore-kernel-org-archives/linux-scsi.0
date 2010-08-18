From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] fusion: add function parameter names to kernel-doc
Date: Wed, 18 Aug 2010 17:39:40 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249029923AB35@inbmail02.lsi.com>
References: <20100814130557.100acad5.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:55409 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668Ab0HRMJt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2010 08:09:49 -0400
In-Reply-To: <20100814130557.100acad5.randy.dunlap@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, "Moore, Eric" <Eric.Moore@lsi.com>, akpm <akpm@linux-foundation.org>

Acked this patch.

~Kashyap

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Randy Dunlap
> Sent: Sunday, August 15, 2010 1:36 AM
> To: scsi
> Cc: torvalds; Moore, Eric; akpm
> Subject: [PATCH] fusion: add function parameter names to kernel-doc
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix fusion missing kernel-doc:
> 
> Warning(drivers/message/fusion/mptbase.c:649): No description found for
> parameter 'func_name'
> Warning(drivers/message/fusion/mptbase.c:8010): No description found
> for parameter 'cb_idx'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/message/fusion/mptbase.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-2.6.35-git8.orig/drivers/message/fusion/mptbase.c
> +++ linux-2.6.35-git8/drivers/message/fusion/mptbase.c
> @@ -629,6 +629,7 @@ mptbase_reply(MPT_ADAPTER *ioc, MPT_FRAM
>   *	mpt_register - Register protocol-specific main callback handler.
>   *	@cbfunc: callback function pointer
>   *	@dclass: Protocol driver's class (%MPT_DRIVER_CLASS enum value)
> + *	@func_name: call function's name
>   *
>   *	This routine is called by a protocol-specific driver (SCSI host,
>   *	LAN, SCSI target) to register its reply callback routine.  Each
> @@ -8004,6 +8005,7 @@ mpt_spi_log_info(MPT_ADAPTER *ioc, u32 l
>   *	mpt_sas_log_info - Log information returned from SAS IOC.
>   *	@ioc: Pointer to MPT_ADAPTER structure
>   *	@log_info: U32 LogInfo reply word from the IOC
> + *	@cb_idx: callback function's handle
>   *
>   *	Refer to lsi/mpi_log_sas.h.
>   **/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
