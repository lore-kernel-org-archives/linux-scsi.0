From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH, 2.6] tmscsim - no internal command-queuing
Date: 01 Feb 2004 10:41:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075650115.1756.3.camel@mulgrave>
References: <Pine.LNX.4.44.0401310015520.8401-200000@poirot.grange>
	<20040201111726.A14042@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:18336 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265346AbUBAPmD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Feb 2004 10:42:03 -0500
In-Reply-To: <20040201111726.A14042@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Kurt Garloff <kurt@garloff.de>

On Sun, 2004-02-01 at 06:17, Christoph Hellwig wrote:
> +
> + requeue:
> +    DC390_UNLOCK_ACB;
> +    return 1;

Since this is a host pausing requeue, the return value should be
SCSI_MLQUEUE_HOST_BUSY.

James


