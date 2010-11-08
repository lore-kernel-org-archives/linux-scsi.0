From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/9] target: remove SHUTDOWN_SIGS
Date: Mon, 8 Nov 2010 17:31:38 -0500
Message-ID: <20101108223138.GA23820@infradead.org>
References: <20101108155601.872926000@canuck.infradead.org>
 <20101108155647.434861866@canuck.infradead.org>
 <1289254869.27226.84.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab0KHWbk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 17:31:40 -0500
Content-Disposition: inline
In-Reply-To: <1289254869.27226.84.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Joe Eykholt <jeykholt@cisco.com>

On Mon, Nov 08, 2010 at 02:21:09PM -0800, Nicholas A. Bellinger wrote:
> This patch is not quite correct as drivers/target/lio-target/ is
> currently the last code *not* using linux/kthread.h in the tree.  I
> recall running into some issue wrt to kernel sockets + signals during
> the original convertion use kthread.h, but I don't recall the specifics
> atm.  For now I will drop the lio-target part of this patch, and have a
> look at doing this conversion to kthread.h properly during the
> drivers/target/lio-target review for Boaz in the upcoming week.

Ok, skip that part for now.  I meant to delete it from the patch anyway.

