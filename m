From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/8] scsi: use get_unaligned_* helpers
Date: Mon, 05 May 2008 13:46:16 -0500
Message-ID: <481F55F8.1040606@cs.wisc.edu>
References: <1209700376.22362.19.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33415 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755875AbYEESql (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2008 14:46:41 -0400
In-Reply-To: <1209700376.22362.19.camel@brick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/scsi/libiscsi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 010c1b9..7646e86 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -508,7 +508,7 @@ invalid_datalen:
>  			goto out;
>  		}
>  
> -		senselen = be16_to_cpu(get_unaligned((__be16 *) data));
> +		senselen = get_unaligned_be16(data);
>  		if (datalen < senselen)
>  			goto invalid_datalen;
>  

This looks ok. Thanks.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

If It does not get picked up by Andrew then I will send it with the 
other iscsi updates when the next feature window opens.
