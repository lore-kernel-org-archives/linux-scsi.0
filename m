From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] esp: tidy up target reference counting
Date: Mon, 23 Jun 2008 14:58:28 -0700 (PDT)
Message-ID: <20080623.145828.60746793.davem@davemloft.net>
References: <1214250729.3310.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59183
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753000AbYFWV62 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2008 17:58:28 -0400
In-Reply-To: <1214250729.3310.24.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Mon, 23 Jun 2008 14:52:09 -0500

> The esp driver currently does hand rolled reference counting of its
> target.  It's much easier to do what it needs to do if it's plugged into
> the mid-layer callbacks (target_alloc and target_destroy) which were
> designed for this case, so do it this way and get rid of the internal
> target reference count.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

Much cleaner, thanks!

Signed-off-by: David S. Miller <davem@davemloft.net>
