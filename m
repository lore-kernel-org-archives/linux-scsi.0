From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 1/5] NCR5380: Whitespace cleanup
Date: Thu, 2 Oct 2014 21:07:30 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1410022104070.22727@nippy.intranet>
References: <1412246593-107001-1-git-send-email-hare@suse.de> <1412246593-107001-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:60595 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaJBLIm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 07:08:42 -0400
In-Reply-To: <1412246593-107001-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@parallels.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Webb Scales <webbnh@hp.com>, linux-scsi@vger.kernel.org


On Thu, 2 Oct 2014, Hannes Reinecke wrote:

> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/NCR5380.c | 652 +++++++++++++++++++++++++------------------------
>  1 file changed, 333 insertions(+), 319 deletions(-)
> 

This is going to break about 30 or 40 patches that I'm working on. Can we 
not do this yet? The white space clean up is a smaller patch if it happens 
after all the other bug fixing and modernization work.

-- 
