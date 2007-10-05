From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2/17] sym53c8xx: Use pci_dev irq number
Date: Fri, 05 Oct 2007 16:51:19 -0400
Message-ID: <4706A3C7.5070302@garzik.org>
References: <11916141143747-git-send-email-matthew@wil.cx> <11916141142823-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33102 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbXJEUvY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Oct 2007 16:51:24 -0400
In-Reply-To: <11916141142823-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> Don't cache a private copy of the interrupt number
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/scsi/sym53c8xx_2/sym_glue.c |    7 +++----
>  drivers/scsi/sym53c8xx_2/sym_glue.h |    1 -
>  2 files changed, 3 insertions(+), 5 deletions(-)

ACK patches 1-2


