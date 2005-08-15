From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] aic79xx: sane pci probing
Date: Mon, 15 Aug 2005 12:21:51 -0400
Message-ID: <4300C11F.3010406@pobox.com>
References: <20050815112846.GB17458@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:31674 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S964812AbVHOQV6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 12:21:58 -0400
In-Reply-To: <20050815112846.GB17458@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> remove ahd_tailq and do sane pci probing.  ported over from aic7xxx.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Make sure this gets tested before its applied.

	Jeff



