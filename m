From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bugme-new] [Bug 8122] New: Scsi_Host's n_io_port forgot to be initialized?
Date: Tue, 6 Mar 2007 07:31:45 +0000
Message-ID: <20070306073145.GA23842@infradead.org>
References: <200703040919.l249JWSs008220@fire-2.osdl.org> <20070305191730.8f695adf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59523 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005AbXCFHbr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2007 02:31:47 -0500
Content-Disposition: inline
In-Reply-To: <20070305191730.8f695adf.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, shanlu@cs.uiuc.edu

On Mon, Mar 05, 2007 at 07:17:30PM -0800, Andrew Morton wrote:
> > Most recent kernel where this bug did *NOT* occur: No
> > Distribution: Linux-2.6.20
> > Problem Description:
> > It seems that usually structure Scsi_Host's io_port field and n_io_port field
> > needs to be set together.

io_port and n_io_port are legacy fields left over purely for driver use.
The scsi midlayer doesn't care, and if you want to "fix" things in this
area please just remove use of it from the offending driver completely
so might be able to get rid of these fields one day.

