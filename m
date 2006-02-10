From: Christoph Hellwig <hch@infradead.org>
Subject: Re: read only scsi disk
Date: Fri, 10 Feb 2006 10:35:37 +0000
Message-ID: <20060210103537.GA27401@infradead.org>
References: <1139504647.9367.57.camel@localhost.localdomain> <20060209190225.GI1593@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:64426 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751307AbWBJKfj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 05:35:39 -0500
Content-Disposition: inline
In-Reply-To: <20060209190225.GI1593@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ming Zhang <mingz@ele.uri.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Damian Pietras <daper@daper.net>

On Thu, Feb 09, 2006 at 12:02:25PM -0700, Matthew Wilcox wrote:
> On Thu, Feb 09, 2006 at 12:04:07PM -0500, Ming Zhang wrote:
> > We are adding the support for an OSS iscsi target to support export an
> > iscsi disk as readonly. We set correct read only bit in sense dbd. But
> > we found that only when we set the removable bit, the linux will
> > actually check the ro bit. more detail information can be found from
> 
> Surely all iSCSI discs are removable, since anyone could unplug the
> network cable at any time ...

The removable flags means a removeable medium.  All devices are treated as
beeing able to just go away when the transport is disconnected or the HBA
removed.

