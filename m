From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] dont decrement counters from scsi_kill_request
Date: Wed, 4 Jan 2006 08:05:18 +0000
Message-ID: <20060104080518.GO27946@ftp.linux.org.uk>
References: <1136360688.9634.2.camel@max> <200601040852.15700@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:11758 "EHLO
	ZenIV.linux.org.uk") by vger.kernel.org with ESMTP id S1751205AbWADIFZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jan 2006 03:05:25 -0500
Content-Disposition: inline
In-Reply-To: <200601040852.15700@bilbo.math.uni-mannheim.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike@sf-mail.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

On Wed, Jan 04, 2006 at 08:51:57AM +0100, Rolf Eike Beer wrote:
> Mike Christie wrote:
> 
> >+	while (end_that_request_first(req, 0, req->nr_sectors))
> >+		;
> 
> This should be something like
> 
> while (...)
> 	{}
> 
> so it is absolutely clear that the empty body is intentional.

Please, do not inflict that ugliness on everyone.  FWIW, it's less
idiomatic than normal use of ; and personally I'd parse it as "somebody
had fscked up using editor", not as "wow, they _really_ meant it to be
an empty body".
