From: Karen Shaeffer <shaeffer@neuralscape.com>
Subject: Re: latest 2.6 patch for dpt_i20 driver
Date: Mon, 26 Jan 2004 16:25:59 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040127002559.GA18475@synapse.neuralscape.com>
References: <20040126120908.GA40438@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from synapse.neuralscape.com ([198.144.200.82]:13952 "EHLO
	neuralscape.com") by vger.kernel.org with ESMTP id S265734AbUA0A0j
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2004 19:26:39 -0500
Content-Disposition: inline
In-Reply-To: <20040126120908.GA40438@xs4all.nl>
List-Id: linux-scsi@vger.kernel.org
To: Jasper Slits <slits@xs4all.nl>
Cc: linux-scsi@vger.kernel.org

On Mon, Jan 26, 2004 at 01:09:09PM +0100, Jasper Slits wrote:
> I managed to get dpt_i2o working with kernel 2.6.1-rc2. 
> 
> First of it all, it's still risky to do it. But here is how:
> 
> get Mark's patch -> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=107210932819564&w=2
> 
> Hack the ./drivers/scsi/dpt_i2o.c and remove all references to the
> access_count member. 

Thanks for your comments.

I actually got the latest patch from Mark over at Adaptec. This patch wraps
all the access_count references in ifdefs, so I didn't have to make any
modifications. It compiled and runs as is.

Thanks again,
Karen
-- 
 Karen Shaeffer
 Neuralscape, Palo Alto, Ca. 94306
 shaeffer@neuralscape.com  http://www.neuralscape.com
