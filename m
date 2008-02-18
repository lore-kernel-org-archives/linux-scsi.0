From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: bidi bio map failure fix
Date: Mon, 18 Feb 2008 18:25:01 +0100
Message-ID: <20080218172500.GF23197@kernel.dk>
References: <20080212204024.GA13643@osc.edu> <1202850758.3137.135.camel@localhost.localdomain> <20080218125508.GA23197@kernel.dk> <20080218233719R.tomof@acm.org> <20080218144652.GE23197@kernel.dk> <1203347347.3324.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:26530 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbYBRRZF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 12:25:05 -0500
Content-Disposition: inline
In-Reply-To: <1203347347.3324.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <tomof@acm.org>, pw@osc.edu, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

On Mon, Feb 18 2008, James Bottomley wrote:
> On Mon, 2008-02-18 at 15:46 +0100, Jens Axboe wrote:
> > Seems symmetric to me now, either we fail and everything is cleaned up,
> > or return success. What remains?
> 
> My main symmetry complaint was the API:  The map takes a request, the
> unmap takes a bio.

Oh that, well that was done to make it easier for existing users. Feel
free to send a patch changing that, however it was done that way on
purpose at the time being.

-- 
Jens Axboe

