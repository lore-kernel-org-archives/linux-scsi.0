From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_requeuest_fn
Date: Tue, 29 Apr 2003 08:45:18 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030429084518.A23295@infradead.org>
References: <20030427170440.A29493@lst.de> <20030427110711.A21878@beaverton.ibm.com> <20030427205303.A31125@lst.de> <20030428101411.A27787@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from carisma.slowglass.com ([195.224.96.167]:42001 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261989AbTD2HdE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2003 03:33:04 -0400
Content-Disposition: inline
In-Reply-To: <20030428101411.A27787@beaverton.ibm.com>; from patmans@us.ibm.com on Mon, Apr 28, 2003 at 10:14:11AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Apr 28, 2003 at 10:14:11AM -0700, Patrick Mansfield wrote:
> I compiled and booted (on one machine with aic driver) with all but the
> first (the header split up) and last patch (changes to drivers I don't
> use) applied.
> 
> The header split up had a conflict with the nuke externs, plus the
> missing include mentioned in a separate email.

oh well, that happens if you need to split up the huge delta of
your working tree vs the upstream tree manually :P  I'll only hope
that James could apply some of the patches so this delta gets down a bit..

