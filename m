From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid 32/64 ioctl support (update)
Date: Wed, 16 Jun 2004 18:53:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040616175325.GA16751@infradead.org>
References: <1087401137.13488.61.camel@markh1.pdx.osdl.net> <20040616160107.GA14144@infradead.org> <20040616160232.GB14144@infradead.org> <1087405920.13488.82.camel@markh1.pdx.osdl.net> <20040616171924.GA15925@infradead.org> <1087408316.13488.93.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:21917 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S264312AbUFPRx1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 13:53:27 -0400
Content-Disposition: inline
In-Reply-To: <1087408316.13488.93.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org

> > Although the compat_alloc_user_space implementations I looked at don't fail I
> > think a check for NULL wouldn't hurt.
> 
> The places that I looked where they check the return value use
> access_ok().  What do you think?

 
> > > +	f = compat_alloc_user_space(sizeof(*f));
> 
> I just noticed this.  Can we use memset on a user pointer?  If not, what
> would be the best way to handle this?


Good question.  Maybe the architecture-folks know an answer?
 
