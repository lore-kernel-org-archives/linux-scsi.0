From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Latest update to scsi-misc-2.6
Date: Mon, 31 Oct 2005 17:38:09 +0000
Message-ID: <20051031173809.GA9743@infradead.org>
References: <1130778840.24530.20.camel@markh1.pdx.osdl.net> <1130779948.3293.35.camel@mulgrave> <1130780179.24530.21.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33934 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932489AbVJaRiN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 12:38:13 -0500
Content-Disposition: inline
In-Reply-To: <1130780179.24530.21.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Oct 31, 2005 at 09:36:19AM -0800, Mark Haverkamp wrote:
> > My best guess is that your merge programme is confused.  I've had to
> > merge the tree up several times to fix conflicts, but it's the same
> > tree.  It looks like whatever tool you used to merge failed to recognise
> > this.
> 
> OK, Thanks,  Maybe I need to update my git tools.

I recently had odd merge problems aswell.  I decided to kill the tree
and recheckout but I got even more odd problems.  Upgrading to the latest
git release helped.

Wishing we'd have a mature SCM once again..

