From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sysfs host name support
Date: Mon, 9 Feb 2004 16:20:36 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040209162036.A23821@infradead.org>
References: <20040209155046.GP3944@tpkurt.garloff.de> <20040209160526.A23604@infradead.org> <1076342962.1804.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:6673 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265216AbUBIQUj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2004 11:20:39 -0500
Content-Disposition: inline
In-Reply-To: <1076342962.1804.14.camel@mulgrave>; from James.Bottomley@steeleye.com on Mon, Feb 09, 2004 at 11:09:20AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Mon, Feb 09, 2004 at 11:09:20AM -0500, James Bottomley wrote:
> On Mon, 2004-02-09 at 11:05, Christoph Hellwig wrote:
> > name is optional (you can use ->info instead), so please don't export it.
> > As for proc_name vs module_name - I think we should just export one of them,
> > I'm pretty open which one.  proc_name probably makes more sense.
> 
> Actually, no, I'd like to see module name as well.
> We need a more generic than SCSI solution for this, I think,

Agreed, this makes sense in common code.  In fact I remember the
driver model people were talking about it a while ago.

