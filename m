From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: Tue, 4 Nov 2003 07:10:02 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031104071001.A10128@infradead.org>
References: <1067450547.3112.363.camel@compaq.xsintricity.com> <20031029183159.GE25237@parcelfarce.linux.theplanet.co.uk> <1067453148.3112.369.camel@compaq.xsintricity.com> <4159000000.1067644546@aslan.btc.adaptec.com> <1067644902.1782.20.camel@mulgrave> <1067645285.3112.538.camel@compaq.xsintricity.com> <4168130000.1067645818@aslan.btc.adaptec.com> <20031101012231.GA2346@beaverton.ibm.com> <1067654044.2464.29.camel@mulgrave> <20031103181051.GA21012@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:47885 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263768AbTKDHKI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2003 02:10:08 -0500
Content-Disposition: inline
In-Reply-To: <20031103181051.GA21012@beaverton.ibm.com>; from andmike@us.ibm.com on Mon, Nov 03, 2003 at 10:10:51AM -0800
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <willy@debian.org>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

Umm, the code implementing ->slave_destroy may no more exist when the
scsi_device reference count hits zero..

-- 
Christoph Hellwig <hch@lst.de>		-	Freelance Hacker
Contact me for driver hacking and kernel development consulting
