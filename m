From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 4/10][RFC] linux-iscsi driver
Date: Mon, 10 Jan 2005 18:45:18 -0600
Message-ID: <1105404318.4477.18.camel@mulgrave>
References: <41E30855.9050203@cs.wisc.edu>
	 <20050110232442.GB10138@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:25066 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262626AbVAKApf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 19:45:35 -0500
In-Reply-To: <20050110232442.GB10138@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-01-10 at 23:24 +0000, Christoph Hellwig wrote:
> Can you kill the ugly iscsi-sfnet name?  We also don't call out networking
> code ipv4-swansea ;-)  Simple iscsi should be enough, or if you think that's
> confusing vs driver for hardware offload cards maybe sw-iscsi.

Please not that can of worms again.

For the time being I think iscsi-sfnet will do since there's still one
other possible linux iscsi stack around.  And we would probably have
called our networking code ipv4-swansea if we also had an ipv4-bsd or
something else one could use.

In the long run, there will be only a single iscsi driver, and it can be
renamed as such, but in the short term we're not ready to choose.

James

