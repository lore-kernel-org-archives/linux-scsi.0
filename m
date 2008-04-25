From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH scsi-rc-fixes-2.6] mvsas: fix error handling.
Date: Fri, 25 Apr 2008 11:51:37 -0400
Message-ID: <4811FE09.10209@garzik.org>
References: <47FB498A.2010107@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40433 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294AbYDYPvk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 11:51:40 -0400
In-Reply-To: <47FB498A.2010107@marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: kewei@marvell.com, linux-scsi@vger.kernel.org

Ke Wei wrote:
>  Changed error handling: Add a internal queue to send command in mvs_task_abort function.
>  Set max_id and max_lun to a valid value. It's good for 64xx chip.
>  BTW, DVD-ROM compatibility needs to test carefully.
> 
> 
> Signed-off-by: Ke Wei <kewei@marvell.com>

James, ping?

Did this get missed?  Are we waiting on Marvell to update this patch?

