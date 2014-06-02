From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH 0/4] mpt2/mpt3 static checker fixups
Date: Mon, 2 Jun 2014 16:44:01 -0400
Message-ID: <20140602164401.36420ca1@jlaw-desktop.mno.stratus.com>
References: <1401719672-18352-1-git-send-email-joe.lawrence@stratus.com>
	<20140602163307.GE26828@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o149.mxlogic.net ([208.65.145.72]:43542 "EHLO
	p01c12o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbaFBUoF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 16:44:05 -0400
In-Reply-To: <20140602163307.GE26828@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

On Mon, 2 Jun 2014 09:33:07 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jun 02, 2014 at 10:34:28AM -0400, Joe Lawrence wrote:
> > Hello Sreekanth, Dan,
> > 
> > These are a few minor smatch and sparse static checker fixes for the LSI
> > mpt2 and mpt3 drivers.  The first three fix real potential bugs and the
> > last cleans up a noisy complaint from sparse.
> 
> Can you check if any of these also applies to drivers/message/fusion?
> There is tons of copy & paste between all three drivers unfortunately.

The fixes in this patchset don't apply to drivers/message/fusion,
however there are a half-dozen or so warnings that I could take a look
at if the driver is still maintained.

-- Joe
