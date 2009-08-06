From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: QLA2200 causes kernel bug
Date: Thu, 6 Aug 2009 09:49:25 -0700
Message-ID: <20090806164925.GO2453@plap4-2.local>
References: <6e4c20e70908060828xd4a6a8fh801e1d456c39a5f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:25686 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbZHFQtZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2009 12:49:25 -0400
Content-Disposition: inline
In-Reply-To: <6e4c20e70908060828xd4a6a8fh801e1d456c39a5f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Georgiou <tageorgiou@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 06 Aug 2009, Thomas Georgiou wrote:

> Whenever I have the qla2xxx module loaded, some kernel problem
> eventually occurs.  Sometimes its an oops, a bug, or once, a crash.
> The same thing has been seen to happen on 3 different machines all
> with qla2200 cards in them.
> 
> Here is the latest backtrace:
> [42151.610011] kernel BUG at drivers/scsi/scsi_transport_fc.c:3022!
> [42151.610011] invalid opcode: 0000 [#1] SMP

This looks similar to:

	http://thread.gmane.org/gmane.linux.scsi/49853/focus=50297

with a proposed (though not-liked) solution here:

	http://article.gmane.org/gmane.linux.scsi/50297

Could someone refresh my memory, why was there an issue with re-adding
rports after dev-loss-tmo triggered?


Thomas, could you forward the full messages file?  I'm interested in
seeing what series of events led up to the BUG_ON().  The snippets
here and in the bugzilla only document the failing point BUG_ON().
Also, could you get a test run with the driver error-logging enabled
as well:

	$ modprobe -v qla2xxx ql2xextended_error_logging=1

-- av
