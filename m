From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND number 2] libata: eliminate the home grown dma
	padding in favour of that provided by the block layer
Date: Fri, 01 Feb 2008 15:09:35 -0600
Message-ID: <1201900175.3134.67.camel@localhost.localdomain>
References: <1199138168.3110.12.camel@localhost.localdomain>
	 <1200698057.3111.68.camel@localhost.localdomain>
	 <1201894847.3134.59.camel@localhost.localdomain>
	 <47A37AF3.3030503@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57893 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbYBAVJh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 16:09:37 -0500
In-Reply-To: <47A37AF3.3030503@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Tejun Heo <htejun@gmail.com>


On Fri, 2008-02-01 at 15:02 -0500, Jeff Garzik wrote:
> James Bottomley wrote:
> > Could we please get this in ... I thought I mentioned several times that
> > it fixes a fatal oops in both aic94xx and ipr.
> 
> Tejun has a persistent objection...  see other email.

Actually, see other email .. I meant that this patch (eliminate dma
padding) is independent of the drain one.

James


