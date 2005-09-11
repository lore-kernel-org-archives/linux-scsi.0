From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE 0/2] Serial Attached SCSI (SAS) support for the Linux kernel
Date: Sun, 11 Sep 2005 10:20:30 +0100
Message-ID: <20050911092030.GA5140@infradead.org>
References: <4321E2C1.7080507@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36037 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964826AbVIKJUb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Sep 2005 05:20:31 -0400
Content-Disposition: inline
In-Reply-To: <4321E2C1.7080507@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>


Thanks for finally posting your code.

At the core it's some really nice code dealing with host-based SAS
implementations.  What's not nice is that it's not intgerating with the
SAS transport class I posted, it's duplicating things like LUN disocvery
from the SCSI core code, and adding it's own sysfs representation that's
very different from the way the SCSI core and transport classes do it.

Are you willing to work with us to intgerate it with the infrastructure
we have?
