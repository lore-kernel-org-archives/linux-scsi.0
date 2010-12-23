From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: fix compile failure in linux-next
Date: Thu, 23 Dec 2010 14:52:04 -0800
Message-ID: <1293144724.4649.187.camel@haakon2.linux-iscsi.org>
References: <1293036459.3019.46.camel@mulgrave.site>
	 <1293144172.4649.177.camel@haakon2.linux-iscsi.org>
	 <1293144604.10141.20.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50111 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab0LWW57 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Dec 2010 17:57:59 -0500
In-Reply-To: <1293144604.10141.20.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>

On Thu, 2010-12-23 at 16:50 -0600, James Bottomley wrote:
> On Thu, 2010-12-23 at 14:42 -0800, Nicholas A. Bellinger wrote:
> > On Wed, 2010-12-22 at 10:47 -0600, James Bottomley wrote:
> > > The interfaces open/close_bdev_exclusive are being eliminated in the
> > > merge window.  Fix by using the replacements.
> > > 
> > > James
> > > 
> > 
> > Hi James,
> > 
> > If you don't mind I am going to let srf carry this patch for now, and I
> > will begin a 'for-linux-next' branch to prevent future breakage from
> > drivers/target/.
> 
> It's already done.  The point about postmerge trees is to fix this type
> of thing.
> 

Ahhh, thanks for the clarification here.  I will try my best to prevent
this type of conflict for linux-next in the future.

Best Regards,

--nab

