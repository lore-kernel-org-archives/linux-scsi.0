From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI sym53c8xx_2: bigger transfer limits
Date: Tue, 28 Feb 2006 13:41:22 -0700
Message-ID: <20060228204122.GL27759@parisc-linux.org>
References: <Pine.LNX.4.63.0602282104040.6272@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:29088 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932566AbWB1UlX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 15:41:23 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0602282104040.6272@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

On Tue, Feb 28, 2006 at 09:14:31PM +0200, Kai Makisara wrote:
> This patch enables clustering and sets max_sectors to 0xffff to enable 
> reading and writing of large blocks with tapes (and large transfers with 
> sg). This change is needed after the sg and st drivers started using 
> chained bios through scsi_request_async() in 2.6.16.

Seems  entirely reasonable  to me.  Did you  want this in 2.6.16, or is
2.6.17 soon enough?
