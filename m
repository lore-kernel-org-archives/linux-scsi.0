From: Clay Haapala <chaapala@cisco.com>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: Tue, 10 Feb 2004 16:47:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yqujk72umu16.fsf@chaapala-lnx2.cisco.com>
References: <20040120132052.GA6740@lst.de>
	<2432440000.1076430858@aslan.btc.adaptec.com >
	<1076431366.1804.24.camel@mulgrave>
	<2472850000.1076435243@aslan.btc.adaptec.com>
	<1076438507.2165.38.camel@mulgrave>
	<2520610000.1076442259@aslan.btc.adaptec.com>
	<1076443541.2080.56.camel@mulgrave>
	<2549730000.1076444817@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:35451 "EHLO
	rtp-iport-2.cisco.com") by vger.kernel.org with ESMTP
	id S261950AbUBJWrY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 17:47:24 -0500
In-Reply-To: <2549730000.1076444817@aslan.btc.adaptec.com> (Justin T.
 Gibbs's message of "Tue, 10 Feb 2004 13:26:57 -0700")
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Some of this queuing/retry conversation sounds similar to the recent
discussion we had on the linux-iscsi driver.  I think that the
linux-iscsi ended up OK on it, but it is something to keep in mind for
the reviewers of the 4.0.0.4 version to see if we got it right.

On a related topic:
On Tue, 10 Feb 2004, Justin T. Gibbs told this:
> [ queuing/retry discussion between Justin and James omitted ]
> That reminds me.  Reported bus/target resets do not cause a
> bus/device-settle delay.  This is another one of the workarounds
> in my driver.

Is this the scenario where the device resets and issues a couple of
"Unit Attentions", etc.?
-- 
Clay Haapala (chaapala@cisco.com) Cisco Systems SRBU +1 763-398-1056
   6450 Wedgwood Rd, Suite 130 Maple Grove MN 55311 PGP: C89240AD
"Honor thy prototypes, that it may be well with thee, and thou mayest
   code long upon the Earth, else thy iniquity will be visited unto
      the third and fourth generation of those that revise it."
