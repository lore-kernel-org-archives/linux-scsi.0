From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] scsi_requeuest_fn
Date: Mon, 28 Apr 2003 10:14:11 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030428101411.A27787@beaverton.ibm.com>
References: <20030427170440.A29493@lst.de> <20030427110711.A21878@beaverton.ibm.com> <20030427205303.A31125@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:51960 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S261210AbTD1RFm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Apr 2003 13:05:42 -0400
Content-Disposition: inline
In-Reply-To: <20030427205303.A31125@lst.de>; from hch@lst.de on Sun, Apr 27, 2003 at 08:53:03PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Sun, Apr 27, 2003 at 08:53:03PM +0200, Christoph Hellwig wrote:
> 
> > Also - do you have a patch rollup somewhere (in case these recent
> > patches aren't applied soon)?
> 
> Currently I don't have.  I'll merge everything together if this isn't
> applied until tomorrow.
> 

FYI -

I compiled and booted (on one machine with aic driver) with all but the
first (the header split up) and last patch (changes to drivers I don't
use) applied.

The header split up had a conflict with the nuke externs, plus the
missing include mentioned in a separate email.

-- Patrick Mansfield
