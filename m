From: "David S. Miller" <davem@davemloft.net>
Subject: Re: recent scsi changes break fc4 build
Date: Sun, 19 Jun 2005 12:56:18 -0700 (PDT)
Message-ID: <20050619.125618.80030021.davem@davemloft.net>
References: <20050618.231646.91312440.davem@davemloft.net>
	<20050619094237.GA5352@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:34502
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S261301AbVFST47 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 15:56:59 -0400
In-Reply-To: <20050619094237.GA5352@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Sun, 19 Jun 2005 10:42:37 +0100

> Sorry Dave, but fc4 is broken beyon imagination and not mentioned in
> the common drivers/Kconfig at all.  My suggestion to fix it is an
> rm -rf.

It doesn't take much work to cross compile check the changes
you made, Al Viro has very easy descriptions of how to set
this up.

Please fix the build, thanks.
