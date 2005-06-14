From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/11]  qla2xxx: Final glue-code for ISP24xx.
Date: Tue, 14 Jun 2005 22:50:44 +0100
Message-ID: <20050614215044.GE5849@infradead.org>
References: <20050614053136.12127.506.sendpatchset@plap.qlogic.com> <20050614053217.12127.19802.sendpatchset@plap.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:39891 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261363AbVFNVuq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 17:50:46 -0400
Content-Disposition: inline
In-Reply-To: <20050614053217.12127.19802.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jun 13, 2005 at 10:32:17PM -0700, Andrew Vasquez wrote:
> Final glue-code for ISP24xx.
> 
> Add appropriate glue-code for ISP24xx support within
> OS and initialization sections of driver.

So why is 24xx and 25xx support directly in the main module while
all others aren't?

And while we're at it, it would be really nice if you could add support
for hotplug firmware loading for older chips aswell.

