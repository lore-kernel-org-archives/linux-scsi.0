From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Is it time to kill ide-scsi.c?
Date: Thu, 05 Jul 2007 19:50:00 -0400
Message-ID: <468D83A8.2060804@garzik.org>
References: <468BBCC0.3010007@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:51978 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758028AbXGEXuI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jul 2007 19:50:08 -0400
In-Reply-To: <468BBCC0.3010007@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Boaz Harrosh wrote:
>  I have attempted (below) to convert ide-scsi to the new data
>  accessors and cleanup the !use_sg code paths. Inspecting
>  the code I can see places that still assume scsi_cmnd->request_buffer
>  is a linear char pointer. Though I admit this assumption is hidden
>  behind a flag "test_bit(PC_TRANSFORM, &pc->flags)". Is this an indication
>  that this drivers no longer works? What is needed in order to kill this
>  driver? If no killing is done than please accepted below patch.
> 
>  Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/ide-scsi.c |   48 ++++++++++++++++++++++++++++------------------
>  1 files changed, 29 insertions(+), 19 deletions(-)

This is a very popular driver for some configurations.  I know many 
people that used this for their ATAPI driver, rather than 
ide-{cdrom,floppy,...}

	Jeff



