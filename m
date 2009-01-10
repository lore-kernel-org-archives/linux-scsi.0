From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] iscsi_tcp - make padbuf non-static
Date: Sat, 10 Jan 2009 12:53:46 -0600
Message-ID: <1231613626.3642.44.camel@localhost.localdomain>
References: <200901082058.n08Kwuml015512@localhost.localdomain>
	 <49666ADF.1020703@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37564 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753163AbZAJSxu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2009 13:53:50 -0500
In-Reply-To: <49666ADF.1020703@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Karen Xie <kxie@chelsio.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, erezzi.list@gmail.com

On Thu, 2009-01-08 at 15:06 -0600, Mike Christie wrote:
> Karen Xie wrote:
> > [PATCH] iscsi_tcp - make padbuf non-static
> > 
> > From: Karen Xie <kxie@chelsio.com>
> > 
> > virt_to_page() call should not be used on kernel text and data addresses.
> > virt_to_page() is used by sg_init_one(). So change padbuf to be allocated within iscsi_segment.
> > 
> > Signed-off-by: Karen Xie <kxie@chelsio.com>
> 
> 
> Thanks for finding this.
> 
> Acked-by: Mike Christie <michaelc@cs.wisc.edu>

Could one of you regenerate this against current git head, please, it
seems to have suffered from the iscsi to libiscsi move.

James


