From: Christoph Hellwig <hch@infradead.org>
Subject: Re: recent scsi changes break fc4 build
Date: Sun, 19 Jun 2005 10:42:37 +0100
Message-ID: <20050619094237.GA5352@infradead.org>
References: <20050618.231646.91312440.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:26819 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262226AbVFSJmi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 05:42:38 -0400
Content-Disposition: inline
In-Reply-To: <20050618.231646.91312440.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org

On Sat, Jun 18, 2005 at 11:16:46PM -0700, David S. Miller wrote:
> 
> Please, at the very least, try to compile the changes you send the
> Linus instead of doing a cut&paste job and hoping for the best.
> 
> Thanks a lot.

Sorry Dave, but fc4 is broken beyon imagination and not mentioned in
the common drivers/Kconfig at all.  My suggestion to fix it is an
rm -rf.
