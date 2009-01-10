From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 10/11] scsi: fix bad use of udelay in atp870u.c
Date: Sat, 10 Jan 2009 10:50:11 -0500
Message-ID: <20090110155011.GA22062@infradead.org>
References: <200901092028.n09KSAeI024551@imap1.linux-foundation.org> <20090109205835.GB5069@deprecation.cyrius.com> <20090109130308.bfde281e.akpm@linux-foundation.org> <1231536107.3235.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54767 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZAJPuP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jan 2009 10:50:15 -0500
Content-Disposition: inline
In-Reply-To: <1231536107.3235.50.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Martin Michlmayr <tbm@cyrius.com>, linux-scsi@vger.kernel.org

On Fri, Jan 09, 2009 at 03:21:47PM -0600, James Bottomley wrote:
> It's wrong to silence a warning or build break while keeping the effect
> it was complaining about it's hiding a bug.  Now if the warning is
> wrong, we can take it out of the ARM build ... but I've got to say it
> looks right: the udelay in this driver will lock a UP system solid for
> 2ms.

mdelay exist for a reason.  Even if this code is really bad adding
a comment about that and moving on is better than leaving the too large
udelay there.

