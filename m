From: Christoph Hellwig <hch@infradead.org>
Subject: Re: BusLogic update - take 2
Date: Wed, 21 Jan 2004 13:47:32 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040121134732.B29605@infradead.org>
References: <40062183.D31421D7@primenet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:42511 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263453AbUAUNrd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2004 08:47:33 -0500
Content-Disposition: inline
In-Reply-To: <40062183.D31421D7@primenet.com>; from doyle@primenet.com on Wed, Jan 14, 2004 at 10:13:39PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Bob Doyle <doyle@primenet.com>
Cc: linux-scsi@vger.kernel.org

What's this:?

+#ifndef FAILURE
+#define FAILURE (-1)
+#endif

else the patch looks okay to me
