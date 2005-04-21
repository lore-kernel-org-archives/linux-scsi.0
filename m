From: Christoph Hellwig <hch@infradead.org>
Subject: Re: The future of host_scribble
Date: Thu, 21 Apr 2005 08:46:42 +0100
Message-ID: <20050421074641.GA17184@infradead.org>
References: <20050421002333.GA8556@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:2474 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261489AbVDUHqr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2005 03:46:47 -0400
Content-Disposition: inline
In-Reply-To: <20050421002333.GA8556@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Thu, Apr 21, 2005 at 01:23:33AM +0100, Matthew Wilcox wrote:
> 
> In scsi_cmnd there's an element called host_scribble.  The name and the
> comment by it were sufficiently confusing that I didn't realise that this
> field is basically for the host's private data.  Any objections to something
> like this, assuming I also submit a patch that converts all the drivers?

Actually the situation about private data in scsi_cmnd is worse, there's
another private data, that's the scsi_pointer structure embedded as SCp
member.  If we're going to fix up naming we should find a way to fixup
both an have a sensible name for both embedded and out of struct private
data.  I somehow doubt it's going to happen before we drop support for
gcc 2.95 and thus can use anonymous unions :)
