From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6 patch] drivers/scsi/scsi_transport_fc.c: #0 unused code
Date: Mon, 28 Feb 2005 22:20:19 +0000
Message-ID: <20050228222019.GA19376@infradead.org>
References: <20050228220020.GR4021@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:56045 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261786AbVB1WUV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2005 17:20:21 -0500
Content-Disposition: inline
In-Reply-To: <20050228220020.GR4021@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Feb 28, 2005 at 11:00:20PM +0100, Adrian Bunk wrote:
> This patch #if 0's the following EXPORT_SYMBOL'ed but unused functions:
> - fc_target_block
> - fc_target_unblock
> - fc_host_block
> - fc_host_unblock

A driver using them is scheduled to be merged soon, and at least one
other will be updated to use this.
