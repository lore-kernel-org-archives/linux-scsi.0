From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 22/22] advansys: Update to version 3.5 and remove
 compilation warning
Date: Fri, 24 Apr 2015 02:42:24 -0700
Message-ID: <20150424094224.GB23248@infradead.org>
References: <1429864377-67002-1-git-send-email-hare@suse.de>
 <1429864377-67002-23-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55643 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966783AbbDXJm2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2015 05:42:28 -0400
Content-Disposition: inline
In-Reply-To: <1429864377-67002-23-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Ondrey Zary <linux@rainbow-software.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

>  config SCSI_ADVANSYS
>  	tristate "AdvanSys SCSI support"
> -	depends on SCSI && VIRT_TO_BUS && !ARM
> +	depends on SCSI && !ARM

Care to remove the bogus call to dma_cache_sync and allow compiling on
arm as well?
