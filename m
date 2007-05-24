From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [patch 14/25] SCSI: use irq_handler_t where appropriate
Date: Thu, 24 May 2007 04:31:30 -0700
Message-ID: <20070524113130.GC16513@andrew-vasquezs-computer.local>
References: <200705232141.l4NLfjq9001203@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:14118 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbXEXLbg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 07:31:36 -0400
Content-Disposition: inline
In-Reply-To: <200705232141.l4NLfjq9001203@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, jeff@garzik.org

On Wed, 23 May 2007, akpm@linux-foundation.org wrote:

> Subject: [patch 14/25] SCSI: use irq_handler_t where appropriate
> Message-Id: <200705232141.l4NLfjq9001203@shell0.pdx.osdl.net>
> 
> From: Jeff Garzik <jeff@garzik.org>
> 
> Signed-off-by: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/aacraid/aacraid.h |    2 +-
>  drivers/scsi/qla2xxx/qla_isr.c |    2 +-

ACK -- the qla2xxx changes.
