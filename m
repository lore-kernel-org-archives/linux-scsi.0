From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: Fri, 31 Oct 2003 16:55:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4159000000.1067644546@aslan.btc.adaptec.com>
References: <1067447221.3112.336.camel@compaq.xsintricity.com>	 <1067447490.1829.30.camel@mulgrave>	 <20031029175045.GC25237@parcelfarce.linux.theplanet.co.uk>	 <1067450547.3112.363.camel@compaq.xsintricity.com>	 <20031029183159.GE25237@parcelfarce.linux.theplanet.co.uk> <1067453148.3112.369.camel@compaq.xsintricity.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:24278 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261276AbTJaXvg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2003 18:51:36 -0500
In-Reply-To: <1067453148.3112.369.camel@compaq.xsintricity.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Matthew Wilcox <willy@debian.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

> Yeah, the appropriate time to check that bit would be at
> slave_configure() time.  (Hmmm...I should have documented that...)

BTW, slave_destroy() doesn't seem to be called after a probe
for a target fails due to a selection timeout.  Is this the
expected behavior?  I only keep persistent allocations after
slave_configure() is called, so this doesn't affect my drivers,
but the behavior isn't what I expected.  This is 2.6.0-test9.

--
Justin

