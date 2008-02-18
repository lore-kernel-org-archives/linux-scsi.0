From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] bsg: bidi bio map failure fix
Date: Mon, 18 Feb 2008 09:09:07 -0600
Message-ID: <1203347347.3324.8.camel@localhost.localdomain>
References: <20080212204024.GA13643@osc.edu>
	 <1202850758.3137.135.camel@localhost.localdomain>
	 <20080218125508.GA23197@kernel.dk> <20080218233719R.tomof@acm.org>
	 <20080218144652.GE23197@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35266 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658AbYBRPJN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Feb 2008 10:09:13 -0500
In-Reply-To: <20080218144652.GE23197@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <tomof@acm.org>, pw@osc.edu, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

On Mon, 2008-02-18 at 15:46 +0100, Jens Axboe wrote:
> Seems symmetric to me now, either we fail and everything is cleaned up,
> or return success. What remains?

My main symmetry complaint was the API:  The map takes a request, the
unmap takes a bio.

James


