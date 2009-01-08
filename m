From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug DIF/DIX support
Date: Thu, 08 Jan 2009 18:24:20 -0500
Message-ID: <49668B24.6070903@interlog.com>
References: <yq1y6xr4hos.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40533 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbZAHXYY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2009 18:24:24 -0500
In-Reply-To: <yq1y6xr4hos.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> This patch adds support for DIX and DIF in scsi_debug.  A separate
> buffer is allocated for the protection information.
> 
>  - The dix parameter indicates whether the controller supports DIX
>    (protection information DMA)
> 
>  - The dif parameter indicates whether the simulated storage device
>    supports DIF
> 
>  - The guard parameter switches between T10 CRC(0) and IP checksum(1)
> 
>  - The ato parameter indicates whether the application tag is owned by
>    the disk(0) or the OS(1)
> 
>  - DIF and DIX errors can be triggered using the scsi_debug_opts mask
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Looks good.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
