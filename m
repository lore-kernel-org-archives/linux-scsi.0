From: Frans van Berckel <fberckel@xs4all.nl>
Subject: Re: [PATCH 03/03] mptfusion: Bump version 3.4.19
Date: Mon, 16 May 2011 16:04:42 +0200
Message-ID: <1305554682.1771.19.camel@deblnxsrv222>
References: <1305552879.1771.1.camel@deblnxsrv222>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2618 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab1EPOEs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2011 10:04:48 -0400
In-Reply-To: <1305552879.1771.1.camel@deblnxsrv222>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org

Dear Desai,

Do you know anyone inside LSI is working on a MPT Fusion kernel patch
for version 4? Have seen your company did release 4.26.00 last summer.

MPT Fusion Linux OS Driver Release Notes
Driver Version: mptlinux-4.26.00.00-1
12/07/2010

Thanks,


Frans van Berckel

On Mon, 2011-05-16 at 15:34 +0200, Kashyap, Desai wrote:
> Update version string to 3.4.19
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> ---
> diff --git a/drivers/message/fusion/mptbase.h
> b/drivers/message/fusion/mptbase.h
> index 1735c84..fe90233 100644
> --- a/drivers/message/fusion/mptbase.h
> +++ b/drivers/message/fusion/mptbase.h
> @@ -76,8 +76,8 @@
> #define COPYRIGHT "Copyright (c) 1999-2008 " MODULEAUTHOR
> #endif
> 
> -#define MPT_LINUX_VERSION_COMMON "3.04.18"
> -#define MPT_LINUX_PACKAGE_NAME "@(#)mptlinux-3.04.18"
> +#define MPT_LINUX_VERSION_COMMON "3.04.19"
> +#define MPT_LINUX_PACKAGE_NAME "@(#)mptlinux-3.04.19"
> #define WHAT_MAGIC_STRING "@" "(" "#" ")"
> 
> #define show_mptmod_ver(s,ver)  \


