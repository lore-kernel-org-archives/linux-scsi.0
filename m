From: Christoph Hellwig <hch@infradead.org>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 09:52:10 +0100
Message-ID: <20071015085210.GA23589@infradead.org>
References: <200710112011.22000.rob@landley.net> <20071013220539.GD29934@parisc-linux.org> <1192400672.3351.56.camel@localhost.localdomain> <200710141845.44750.rob@landley.net> <20071015060015.GB32268@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52738 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbXJOIwW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 04:52:22 -0400
Content-Disposition: inline
In-Reply-To: <20071015060015.GB32268@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Rob Landley <rob@landley.net>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Sun, Oct 14, 2007 at 11:00:15PM -0700, Greg KH wrote:
> If you hate USB storage devices using scsi, please use the ub driver,
> that is what it was written for.

The ub driver is a really dumb piece of shit.  It only drivers usb storage
devices using a scsi protocol set, and duplicates the scsi stack in a very
suboptimal way.

