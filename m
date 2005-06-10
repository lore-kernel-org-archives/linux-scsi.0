From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] cciss 2.6; replaces DMA masks with kernel defines
Date: Fri, 10 Jun 2005 12:55:42 -0400
Message-ID: <42A9C60E.3080604@pobox.com>
References: <20050610143453.GA26476@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:47579 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262605AbVFJQ4B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 12:56:01 -0400
In-Reply-To: <20050610143453.GA26476@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mike.miller@hp.com
Cc: akpm@osdl.org, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

mike.miller@hp.com wrote:
> This patch removes our homegrown DMA masks and uses the ones defined in
> the kernel instead.
> Thanks to Jens Axboe for the code. Please consider this for inclusion.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>

You need to add '#include <linux/dma-mapping.h>'

	Jeff



