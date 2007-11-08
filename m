From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [SCSI] sym53c8xx: fix setflag user command to control disconnects
Date: Thu, 8 Nov 2007 18:14:21 +0000
Message-ID: <20071108181421.GB7824@infradead.org>
References: <4732221B.1000104@cybernetics.com> <1194544034.4018.6.camel@localhost.localdomain> <47335135.6010103@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46499 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762328AbXKHSO0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Nov 2007 13:14:26 -0500
Content-Disposition: inline
In-Reply-To: <47335135.6010103@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Thu, Nov 08, 2007 at 01:11:01PM -0500, Tony Battersby wrote:
> HBA is inside an embedded device sold by my company, and customers can
> attach their own SCSI devices to it.  There is one type of SCSI device
> that we support which doesn't work with disconnect privilege enabled, so
> my code running in the embedded device needs to be able to
> enable/disable disconnect privilege dynamically based on whether or not
> the customer has attached this specific broken device.
> 
> It would be nice to have a generic way to control it.  That would save
> me the bother of sending my patch to control disconnect privilege for
> LSI MPT Fusion Ultra320 HBAs via mptctl.  ;-)

Yes, the embedded space is a good enough reason to implement it in the
SPI transport class.  And I think we should take that as an opportunity
to kill the sym2 /proc support or at least the write support.
