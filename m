From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: bug 2400
Date: 06 Apr 2004 09:09:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081260580.1804.22.camel@mulgrave>
References: <20040401131502.41136788.akpm@osdl.org>
	<1080862354.2118.78.camel@mulgrave> <1080949016.1804.161.camel@mulgrave>
	<20040404213307.A29446@beaverton.ibm.com>
	<1081199233.2105.45.camel@mulgrave> <20040406092244.GH28109@suse.de>
	<1081259807.1804.9.camel@mulgrave>  <20040406140433.GE7353@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:44724 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263834AbUDFOL1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2004 10:11:27 -0400
In-Reply-To: <20040406140433.GE7353@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-04-06 at 09:04, Jens Axboe wrote:
> Only change is the err -> error, correct?

Not quite; there was a cleanup goto issue as well (don't want to goto
the release if you couldn't get the object).

> > The attached (hopefully) is what I compiled and tested with.  The test,
> > incidentally, is simply to hold the device open and then forcibly remove
> > it using scsi remove-single-device before closing it.
> 
> Better than what is there, whether it needs other synchronization is a
> different question.

Heh, join the debate, why don't you...

James


