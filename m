From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid 32/64 ioctl support (update)
Date: Wed, 16 Jun 2004 17:02:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040616160232.GB14144@infradead.org>
References: <1087401137.13488.61.camel@markh1.pdx.osdl.net> <20040616160107.GA14144@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:48283 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S264096AbUFPQCe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 12:02:34 -0400
Content-Disposition: inline
In-Reply-To: <20040616160107.GA14144@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Wed, Jun 16, 2004 at 05:01:07PM +0100, Christoph Hellwig wrote:
> > +		register_ioctl32_conversion(2131, NULL);
> > +#	endif
> 
> #ifdef please and no additional indentation inside the ifdef please.

btw, what's ioctl2131?  It doesn't seem to be implemented, so no need to translate it.
