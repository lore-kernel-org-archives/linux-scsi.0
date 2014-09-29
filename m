From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] be2iscsi: check ip buffer before copying
Date: Mon, 29 Sep 2014 12:26:23 -0700
Message-ID: <20140929192623.GA22023@infradead.org>
References: <1412016942-4759-1-git-send-email-michaelc@cs.wisc.edu>
 <1412016942-4759-2-git-send-email-michaelc@cs.wisc.edu>
 <1412017610.6067.18.camel@jarvis.lan>
 <5429AE1D.1040600@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47783 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaI2T0Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Sep 2014 15:26:25 -0400
Content-Disposition: inline
In-Reply-To: <5429AE1D.1040600@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Mon, Sep 29, 2014 at 02:08:13PM -0500, Mike Christie wrote:
> > This looks to be a long standing and potentially exploitable bug ...
> > does it need a cc to stable?
> > 
> 
> Yeah, sorry. Forgot to cc. Do you need me to resend with them ccd?

As mentioned offlist I can just add it, but if you know you want it
in stable releases it's better to just add it from the beginning.

