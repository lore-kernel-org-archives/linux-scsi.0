From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 14/25] SCSI: use irq_handler_t where appropriate
Date: Wed, 23 May 2007 18:07:35 -0400
Message-ID: <4654BB27.6050706@garzik.org>
References: <200705232141.l4NLfjq9001203@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:37791 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195AbXEWWHi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 18:07:38 -0400
In-Reply-To: <200705232141.l4NLfjq9001203@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

akpm@linux-foundation.org wrote:
> From: Jeff Garzik <jeff@garzik.org>
> 
> Signed-off-by: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/aacraid/aacraid.h |    2 +-
>  drivers/scsi/qla2xxx/qla_isr.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

hrm.  This appears to have been sent to linux-scsi at least three times.

If it doesn't stick, I'll go ahead and send it up myself.

	Jeff



