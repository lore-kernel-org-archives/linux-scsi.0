From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 13/17] sym53c8xx: Use scmd_printk where appropriate
Date: Fri, 05 Oct 2007 16:59:12 -0400
Message-ID: <4706A5A0.4000403@garzik.org>
References: <11916141143747-git-send-email-matthew@wil.cx> <1191614115834-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:42456 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761666AbXJEU7O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Oct 2007 16:59:14 -0400
In-Reply-To: <1191614115834-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> If we have a scsi_cmnd, it gives the user more information than the
> sym_name, and maybe the target.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/scsi/sym53c8xx_2/sym_glue.c |    4 ++--
>  drivers/scsi/sym53c8xx_2/sym_hipd.c |   35 +++++++++++++++++------------------
>  2 files changed, 19 insertions(+), 20 deletions(-)

ACK patches 12-13


