From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] remove drivers/fc4/
Date: Sun, 19 Jun 2005 12:57:47 -0700 (PDT)
Message-ID: <20050619.125747.35507641.davem@davemloft.net>
References: <20050619113723.GA18757@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:23448
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S261305AbVFST63 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 15:58:29 -0400
In-Reply-To: <20050619113723.GA18757@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove drivers/fc4/
Date: Sun, 19 Jun 2005 13:37:24 +0200

> This code doesn't work since 2.2.x times, uses various obsolete APIs,
> pokes into the midlayer code where it shouldn't and thus won't even
> have a chance to compile after my next round of patches.
> 
> Let's get rid of it, anyone who wants to resurrect it can find it
> in the archives, and it'll require a major rewrite anyway.

It does work for some people.  People do use it.

It built just fine before changes started going in
lately.  Removing it is not a magic escape hatch you
get to use because you want to change some interfaces
but don't know how to do so without breaking the
driver.
