From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: Wed, 5 Nov 2003 01:26:32 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031105092632.GB6342@beaverton.ibm.com>
References: <20031029183159.GE25237@parcelfarce.linux.theplanet.co.uk> <1067453148.3112.369.camel@compaq.xsintricity.com> <4159000000.1067644546@aslan.btc.adaptec.com> <1067644902.1782.20.camel@mulgrave> <1067645285.3112.538.camel@compaq.xsintricity.com> <4168130000.1067645818@aslan.btc.adaptec.com> <20031101012231.GA2346@beaverton.ibm.com> <1067654044.2464.29.camel@mulgrave> <20031103181051.GA21012@beaverton.ibm.com> <20031104071001.A10128@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:8916 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262784AbTKEJYO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2003 04:24:14 -0500
Content-Disposition: inline
In-Reply-To: <20031104071001.A10128@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <willy@debian.org>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

Christoph Hellwig [hch@infradead.org] wrote:
> Umm, the code implementing ->slave_destroy may no more exist when the
> scsi_device reference count hits zero..
> 

Yes that is my bad. I re-rolled the patch and will run a couple of
tests. I will repost today. 

-andmike
--
Michael Anderson
andmike@us.ibm.com

