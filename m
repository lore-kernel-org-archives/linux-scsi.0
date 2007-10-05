From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 10/17] sym53c8xx: Remove io_ws, mmio_ws and ram_ws elements
Date: Fri, 05 Oct 2007 16:55:59 -0400
Message-ID: <4706A4DF.9090103@garzik.org>
References: <11916141143747-git-send-email-matthew@wil.cx> <11916141153517-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:35536 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761371AbXJEU4B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Oct 2007 16:56:01 -0400
In-Reply-To: <11916141153517-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> These struct elements record info that is never needed
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/scsi/sym53c8xx_2/sym_glue.c |    5 +----
>  drivers/scsi/sym53c8xx_2/sym_glue.h |    1 -
>  drivers/scsi/sym53c8xx_2/sym_hipd.c |    7 ++-----
>  drivers/scsi/sym53c8xx_2/sym_hipd.h |    3 ---
>  4 files changed, 3 insertions(+), 13 deletions(-)

ACK patches 8-10


