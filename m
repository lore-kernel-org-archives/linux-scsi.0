From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 09:44:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030922094404.A1056@beaverton.ibm.com>
References: <20030922004943.E32009@one-eyed-alien.net> <Pine.LNX.4.44L0.0309221001090.1697-100000@ida.rowland.org> <20030922153123.A23388@infradead.org> <20030922161104.A24155@infradead.org> <20030922084930.A679@beaverton.ibm.com> <20030922173732.A25639@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:12744 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S263218AbTIVQpr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 12:45:47 -0400
Content-Disposition: inline
In-Reply-To: <20030922173732.A25639@infradead.org>; from hch@infradead.org on Mon, Sep 22, 2003 at 05:37:32PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Linus Torvalds <torvalds@osdl.org>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Sep 22, 2003 at 05:37:32PM +0100, Christoph Hellwig wrote:
> 
> What I meant is not adding a blist flags member at all but rather
> setting skip_ms_page_8 and skip_ms_page_3f from ->slave_alloc.
> 
> But I probably missed something obvious :)

The current code allows us to set or clear a given bit, but not both. So
if we set them in slave_alloc, they can't be cleared without adding
other flags or code.

-- Patrick Mansfield
