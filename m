From: Arjan van de Ven <arjan@infradead.org>
Subject: RE: [PATCH 7/7] aacraid: sgraw command support
Date: Fri, 05 Aug 2005 16:44:41 +0200
Message-ID: <1123253081.3239.79.camel@laptopd505.fenrus.org>
References: <60807403EABEB443939A5A7AA8A7458B017931EB@otce2k01.adaptec.com>
	 <1123251881.6548.8.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:48807 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262313AbVHEOow (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2005 10:44:52 -0400
In-Reply-To: <1123251881.6548.8.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

On Fri, 2005-08-05 at 07:24 -0700, Mark Haverkamp wrote:
> On Thu, 2005-08-04 at 07:40 -0400, Salyzyn, Mark wrote:
> > In these cases, the 'addr' is an u64, so is it necessary to perform this
> > modification?
> 
> Arjan,
> 
> Do you agree with the above?  If so, is the patch OK as is?

Ok you're ok then. I just then in turn question why addr is actually a
u64, and not say, a dma_addr_t or something..




