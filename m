From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 17/17] sym53c8xx: Remove sym_xpt_async_sent_bdr
Date: Fri, 05 Oct 2007 17:07:56 -0400
Message-ID: <4706A7AC.9020502@garzik.org>
References: <11916141143747-git-send-email-matthew@wil.cx> <11916141152209-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55745 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761872AbXJEVH6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Oct 2007 17:07:58 -0400
In-Reply-To: <11916141152209-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> This function just printed a message to the user; move the print to its
> only caller, and turn it into an starget_printk.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/scsi/sym53c8xx_2/sym_glue.c |    8 --------
>  drivers/scsi/sym53c8xx_2/sym_glue.h |    1 -
>  drivers/scsi/sym53c8xx_2/sym_hipd.c |    3 ++-
>  3 files changed, 2 insertions(+), 10 deletions(-)

ACK


