From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 7/17] sym53c8xx: PCI Error Recovery support
Date: Fri, 05 Oct 2007 16:54:34 -0400
Message-ID: <4706A48A.2040305@garzik.org>
References: <11916141143747-git-send-email-matthew@wil.cx> <11916141142800-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:35518 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761393AbXJEUyh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Oct 2007 16:54:37 -0400
In-Reply-To: <11916141142800-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Linas Vepstas <linas@austin.ibm.com>, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> From: Linas Vepstas <linas@austin.ibm.com>
> 
> This patch adds the PCI error recovery callbacks to the Symbios SCSI device
> driver.  It includes support for First Failure Data Capture.
> 
> Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
> 
> Assorted changes to initial patches, including returning IRQ_NONE from the
> interrupt handler if the device is offline and re-using the eh_done completion
> in the scsi error handler.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/scsi/sym53c8xx_2/sym_glue.c |  179 ++++++++++++++++++++++++++++++++++-
>  drivers/scsi/sym53c8xx_2/sym_glue.h |    3 +
>  drivers/scsi/sym53c8xx_2/sym_hipd.c |   25 ++++-
>  3 files changed, 200 insertions(+), 7 deletions(-)

ACK patches 4-7


