From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] aacraid 2.6: Support for new cards
Date: Thu, 16 Dec 2004 09:09:58 -0800
Message-ID: <1103216998.7662.10.camel@markh1.pdx.osdl.net>
References: <1103063344.15699.27.camel@markh1.pdx.osdl.net>
	 <20041216170359.GA10761@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:38797 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S261941AbULPRKL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2004 12:10:11 -0500
In-Reply-To: <20041216170359.GA10761@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Thu, 2004-12-16 at 17:03 +0000, Christoph Hellwig wrote:
> > +/*
> > + * This adapter is a slave (no Firmware)
> > + */
> > +#define AAC_QUIRK_SLAVE 0x0004
> 
> This is set once but never cleared.
> 
> > +/*
> > + * This adapter is a master.
> > + */
> > +#define AAC_QUIRK_MASTER 0x0008
> 
> And this one is completely unused.

True, they are there for use by a patch to come later.

Mark.


-- 
Mark Haverkamp <markh@osdl.org>

