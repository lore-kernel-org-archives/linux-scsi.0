From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 2/6] aic79xx: Use struct map_node
Date: Thu, 22 Dec 2005 14:58:52 -0500
Message-ID: <43AB057C.60809@pobox.com>
References: <43AAB51E.2090502@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:16571 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S965176AbVLVT6z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2005 14:58:55 -0500
In-Reply-To: <43AAB51E.2090502@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hannes Reinecke wrote:
> [PATCH 2/6] aic79xx: Use struct map_node
> 
> Use struct map_node instead of separate variables.
> ---
> 
>  drivers/scsi/aic7xxx/aic79xx.h        |   29 +++++++++++++++++-----------
>  drivers/scsi/aic7xxx/aic79xx_core.c   |   28 ++++++++++++++++-----------
>  drivers/scsi/aic7xxx/aic79xx_inline.h |   34
> +++++++++++++++++++++++----------
>  3 files changed, 58 insertions(+), 33 deletions(-)
> 
> dc6a17c121389dd95a403b9da25326543af4d05d
> diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
> --- a/drivers/scsi/aic7xxx/aic79xx.h
> +++ b/drivers/scsi/aic7xxx/aic79xx.h
> @@ -1,7 +1,7 @@
>  /*
>   * Core definitions and data structures shareable across OS platforms.
>   *
> - * Copyright (c) 1994-2002 Justin T. Gibbs.
> + * Copyright (c) 1994-2001 Justin T. Gibbs.
>   * Copyright (c) 2000-2002 Adaptec Inc.
>   * All rights reserved.
>   *

Purpose of this change?

	Jeff



