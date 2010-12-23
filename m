From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] target: fix compile failure in linux-next
Date: Thu, 23 Dec 2010 16:50:03 -0600
Message-ID: <1293144604.10141.20.camel@mulgrave.site>
References: <1293036459.3019.46.camel@mulgrave.site>
	 <1293144172.4649.177.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50123 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab0LWWuG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2010 17:50:06 -0500
In-Reply-To: <1293144172.4649.177.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>

On Thu, 2010-12-23 at 14:42 -0800, Nicholas A. Bellinger wrote:
> On Wed, 2010-12-22 at 10:47 -0600, James Bottomley wrote:
> > The interfaces open/close_bdev_exclusive are being eliminated in the
> > merge window.  Fix by using the replacements.
> > 
> > James
> > 
> 
> Hi James,
> 
> If you don't mind I am going to let srf carry this patch for now, and I
> will begin a 'for-linux-next' branch to prevent future breakage from
> drivers/target/.

It's already done.  The point about postmerge trees is to fix this type
of thing.

James


