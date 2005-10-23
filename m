From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH RFC] use struct scsi_lun in generic code
Date: Sun, 23 Oct 2005 01:20:09 -0400
Message-ID: <435B1D89.5070500@pobox.com>
References: <20051023043301.GA22615@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:47808 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751401AbVJWFUQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 01:20:16 -0400
Received: from cpe-069-134-188-146.nc.res.rr.com ([69.134.188.146] helo=[10.10.10.88])
	by mail.dvmed.net with esmtpsa (Exim 4.52 #1 (Red Hat Linux))
	id 1ETYHE-0000AS-5g
	for linux-scsi@vger.kernel.org; Sun, 23 Oct 2005 05:20:15 +0000
In-Reply-To: <20051023043301.GA22615@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> A further experiment:  once dev_printk() has been used to eliminate
> direct references to HCIL address (see previous patch), we can see what
> happens when we update the core to use struct scsi_lun.

Two notes to this patch:

1) A REPORT LUNS [non-sequential] scan works quite nicely with this patch.

2) However, display a valid LUN received from REPORT LUNS will 
inevitably be mangled by scsilun_to_str().  The lun data itself is NOT 
mangled, of course; just the display.

