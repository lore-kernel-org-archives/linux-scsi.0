From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [patch 0/6] marginalize HCIL a bit
Date: Sat, 22 Oct 2005 21:45:49 -0400
Message-ID: <435AEB4D.1050602@pobox.com>
References: <20051023013618.GA18201@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:54975 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751380AbVJWBpy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 21:45:54 -0400
Received: from cpe-069-134-188-146.nc.res.rr.com ([69.134.188.146] helo=[10.10.10.88])
	by mail.dvmed.net with esmtpsa (Exim 4.52 #1 (Red Hat Linux))
	id 1ETUvo-00016T-HD
	for linux-scsi@vger.kernel.org; Sun, 23 Oct 2005 01:45:53 +0000
In-Reply-To: <20051023013618.GA18201@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> This patch series makes a tiny bit of progress on the marginalize-SPI
> todo list.
> 
> Patches:
> 1) s/scsi_scan_target/spi_scan_target/
> 2) remove unused scsi_scan_single_target()
> 3) add scsi_scan_target()
> 4) kill all uses of spi_scan_target()
> 5) kill spi_scan_target(), __spi_scan_target()
> 6) misc cleanups


hmmm.  On second thought, I should probably leave __spi_scan_target() in 
there as a static function, to delete the now duplicated code in 
spi_scan_channel().

