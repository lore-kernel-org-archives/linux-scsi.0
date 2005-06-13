From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] cciss 2.6 DMA mapping
Date: Sun, 12 Jun 2005 23:00:17 -0400
Message-ID: <42ACF6C1.9080603@pobox.com>
References: <20050610195104.GA15149@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:52961 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261347AbVFMDAY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Jun 2005 23:00:24 -0400
In-Reply-To: <20050610195104.GA15149@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mike.miller@hp.com
Cc: akpm@odsl.org, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

mike.miller@hp.com wrote:
> Patch removes our homegrown DMA masks and uses the ones defined in the kernel.
> This patch replaces the broken one I sent in earlier. It has been tested and works. Please discard the first submission.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>

ACK


