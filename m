From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6.2-rc2 - MPT Fusion driver 3.00.02 update
Date: Mon, 26 Jan 2004 19:34:13 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040126193413.A3302@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E5703D19D33@exa-atlanta.se.lsil.com> <1075136727.2290.48.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:46345 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264881AbUAZTeS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2004 14:34:18 -0500
Content-Disposition: inline
In-Reply-To: <1075136727.2290.48.camel@mulgrave>; from James.Bottomley@steeleye.com on Mon, Jan 26, 2004 at 11:05:26AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Moore, Eric Dean" <Emoore@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jan 26, 2004 at 11:05:26AM -0600, James Bottomley wrote:
> > I had avoided it due the comments in the code
> > from sralston and pdelaney about sg interface 
> > gererating wrong direction in some cases.  
> 
> If you find a problem, I'll fix the generic code...

I think it's just very old comments.  We had such a problem in early 2.4
kernels, but it has been fixed for ages.  If it wasn't most of the scsi
drivers would have a big problem.
