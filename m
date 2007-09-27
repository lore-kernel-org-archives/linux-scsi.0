From: Michael Reed <mdr@sgi.com>
Subject: Re: generating a Linux WWN?
Date: Thu, 27 Sep 2007 08:55:23 -0500
Message-ID: <46FBB64B.4040204@sgi.com>
References: <46FB8024.8040807@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55140 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755004AbXI0NzZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 09:55:25 -0400
In-Reply-To: <46FB8024.8040807@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>



Jeff Garzik wrote:
> Is there an accepted way to generate a SAS address, when the adapter
> does not supply one (NVRAM invalid or missing, etc.)?
> 
> Unless somebody complains, I was just planning to use

I'm not complaining.  I'm circulating this for discussion with our
SAS hardware provider and internally.  Give us a little time to
mull this over.

Thanks,
 Mike


> get_random_bytes().  But maybe Linux has an IEEE id we can use, to make
> the practice a bit more legitimate and avoid stomping on others?  Or an
> IEEE id specifically designed for generated-address purposes?
> 
>     Jeff
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
