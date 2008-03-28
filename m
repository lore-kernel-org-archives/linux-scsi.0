From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 05/17] scsi: le*_add_cpu conversion
Date: Fri, 28 Mar 2008 18:09:08 -0400
Message-ID: <47ED6C84.3070304@garzik.org>
References: <200803282148.m2SLmZlt012228@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55229 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbYC1WJN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 18:09:13 -0400
In-Reply-To: <200803282148.m2SLmZlt012228@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, marcin.slusarz@gmail.com, Mark_Salyzyn@adaptec.com

akpm@linux-foundation.org wrote:
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> 
> replace all:
> little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
> 					expression_in_cpu_byteorder);
> with:
> 	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
> generated with semantic patch
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: James.Bottomley@HansenPartnership.com
> Acked-by: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/aacraid/commsup.c |    2 +-
>  drivers/scsi/ips.c             |    8 ++------
>  2 files changed, 3 insertions(+), 7 deletions(-)

Not commenting on the patch, but the API:  it should be le32_add() not 
le32_add_cpu()

	Jeff




