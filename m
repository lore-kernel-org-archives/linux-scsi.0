From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Feral Qlogic ISP driver up for testing
Date: 15 May 2003 12:30:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1053019841.2267.85.camel@mulgrave>
References: <1053017923.2267.76.camel@mulgrave>
	<20030515180341.A30444@infradead.org> <1053018832.2265.81.camel@mulgrave>
	<20030515102358.L12807@wonky.in0.lcl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:57604 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264123AbTEORSx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2003 13:18:53 -0400
In-Reply-To: <20030515102358.L12807@wonky.in0.lcl>
List-Id: linux-scsi@vger.kernel.org
To: mjacob@feral.com
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@digeo.com>

On Thu, 2003-05-15 at 12:25, Matthew Jacob wrote:
> 
> 
> The tarball doesn't get updated as frequently as my BK tree, and the BK
> tree for 2.5 is different...
> 
> bk://bitkeeper.feral.com:9002

Hmm, well, the bitkeeper tree is where I got the files from.

We can certainly hold off on integrating it (that's why I put it into a
separate BK tree).  However, unless there are any really nasty lurking
bugs, I'd like to get those people who can at least to test it.

James


