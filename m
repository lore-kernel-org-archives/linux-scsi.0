From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PATCH] final pre -rc pieces of SCSI for 2.6.14
Date: Fri, 11 Nov 2005 22:23:41 +0000
Message-ID: <20051111222341.GA20077@infradead.org>
References: <1131745742.3505.47.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51937 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751126AbVKKWXs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2005 17:23:48 -0500
Content-Disposition: inline
In-Reply-To: <1131745742.3505.47.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Fri, Nov 11, 2005 at 03:49:01PM -0600, James Bottomley wrote:
>   o remove scsi_wait_req

This requires '[PATCH] kill libata scsi_wait_req usage (make libata compile in
scsi-misc)' from Mike, because libata started to use this function in mainline
about the same time it was removed in scsi-misc.

