From: Jens Axboe <axboe@suse.de>
Subject: Re: bug 2400
Date: Tue, 6 Apr 2004 16:04:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040406140433.GE7353@suse.de>
References: <20040401131502.41136788.akpm@osdl.org> <1080862354.2118.78.camel@mulgrave> <1080949016.1804.161.camel@mulgrave> <20040404213307.A29446@beaverton.ibm.com> <1081199233.2105.45.camel@mulgrave> <20040406092244.GH28109@suse.de> <1081259807.1804.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:13776 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263816AbUDFOFM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 10:05:12 -0400
Content-Disposition: inline
In-Reply-To: <1081259807.1804.9.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Apr 06 2004, James Bottomley wrote:
> On Tue, 2004-04-06 at 04:22, Jens Axboe wrote:
> > Really? It doesn't even compile :-)
> 
> Heh, I really must learn that I have to copy the file from the test
> machine to the email machine *before* attaching it.  You got a stale
> copy of an older incarnation, I think.

Only change is the err -> error, correct?

> The attached (hopefully) is what I compiled and tested with.  The test,
> incidentally, is simply to hold the device open and then forcibly remove
> it using scsi remove-single-device before closing it.

Better than what is there, whether it needs other synchronization is a
different question.

-- 
Jens Axboe

