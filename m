From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] LDM-based scsi host lookup
Date: Wed, 28 May 2003 11:06:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030528090612.GA25119@lst.de>
References: <20030527112550.GB13798@lst.de> <20030528074409.GB2028@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:1475 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264629AbTE1IxA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2003 04:53:00 -0400
Content-Disposition: inline
In-Reply-To: <20030528074409.GB2028@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Wed, May 28, 2003 at 12:44:09AM -0700, Mike Anderson wrote:
> Looks good. One code comment below.
> 
> I have a core class for each child interator patch. Do you think we
> should use that instead. It would protect the SCSI code in case the core
> changed on how class children are protected. It does have a little more
> overhead then your loop though.

Sounds like a good idea.  I'd suggest just taking my patch for
now and switching over to use your function once it's in.

