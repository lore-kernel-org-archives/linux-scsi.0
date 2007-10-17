From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Add suspend/resume support for aic7xxx/aic79xx
Date: Wed, 17 Oct 2007 10:48:54 -0400
Message-ID: <471620D6.10206@garzik.org>
References: <47161877.1090000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:42928 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762269AbXJQOs7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 10:48:59 -0400
In-Reply-To: <47161877.1090000@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hannes Reinecke wrote:
> Hi James,
> 
> due to popular demand I've clobbered together a patch for
> suspend/resume support in aic79xx/aic7xxx.
> 
> Looks reasonable enough, boots, but now I'd need someone
> to actually test it :-)
> 
> As usual, comments, results, fixes, etc. welcome.

Looks good to me...  nice work.

	Jeff



