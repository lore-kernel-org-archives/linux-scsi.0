From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] rm unused scan delay var
Date: Tue, 29 Mar 2005 15:06:36 +0100
Message-ID: <20050329140636.GA28055@infradead.org>
References: <4244FE33.8030004@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:7591 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262287AbVC2OGh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2005 09:06:37 -0500
Content-Disposition: inline
In-Reply-To: <4244FE33.8030004@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Mar 25, 2005 at 10:16:19PM -0800, Mike Christie wrote:
> Is FC_SCSI_SCAN_DELAY used by a FC driver that is
> not yet in mainline? This patch just deletes it
> if not since no one else is.

It's not used by either the Emulex or the rewritten qlogic driver, so
it can probably go away.

