From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/9] target: split CDB emulation out of
 target_core_transport.c
Date: Mon, 8 Nov 2010 17:57:15 -0500
Message-ID: <20101108225715.GA7529@infradead.org>
References: <20101108155601.872926000@canuck.infradead.org>
 <20101108171944.GA778@infradead.org>
 <1289256525.27226.102.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41241 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab0KHW5Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 17:57:16 -0500
Content-Disposition: inline
In-Reply-To: <1289256525.27226.102.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Mon, Nov 08, 2010 at 02:48:45PM -0800, Nicholas A. Bellinger wrote:
> On Mon, 2010-11-08 at 12:19 -0500, Christoph Hellwig wrote:
> > Split out the CDB emulation into it's own file, and refactor it along proper
> > boundaries.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> 
> I think this makes alot sense for the vast majority of the CDB emulation
> code, but I think specifically for the handful of PR and ALUA CDB
> emulation pieces it does make more sense conceptually (and for the sake
> of comments) to keep this code in their respective source files.
> 
> Other than those two cases, I am happy to merge this code.

Currently all the code is in target_core_transport.c, so splitting it
out is a good first stuff.  Further splitting out PR and ALUA helpers
and moving them to the specific source files seems like a good idea,
though.

Btw, I just noticed this only applies without patch 9 applies.  You
should be able to rebase it yourself, if not I'm happy to resend it.
