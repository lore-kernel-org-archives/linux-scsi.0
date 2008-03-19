From: Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] a100u2w: fix bitmap lookup routine
Date: Wed, 19 Mar 2008 10:24:19 -0400
Message-ID: <20080319142419.GA27779@devserv.devel.redhat.com>
References: <20080317123200.GA17756@APFDCB5C> <1205765204.6767.129.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759405AbYCSTtM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 15:49:12 -0400
Content-Disposition: inline
In-Reply-To: <1205765204.6767.129.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>, Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>

On Mon, Mar 17, 2008 at 09:46:44AM -0500, James Bottomley wrote:
> On Mon, 2008-03-17 at 21:32 +0900, Akinobu Mita wrote:
> > This patch is only compile tested.
> 
> It looks fine to me ... I don't suppose we can find someone with an
> actual card to test it out, could we?
> 
> Another observation is that this code is really trying to reinvent
> bitmaps, so if someone with a card cares they could convert it over to
> the linux bitmap infrastructure.

If you want it tested then send me the patch.
