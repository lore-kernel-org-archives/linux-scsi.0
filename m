From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: 31 Oct 2003 20:34:02 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067654044.2464.29.camel@mulgrave>
References: <1067447221.3112.336.camel@compaq.xsintricity.com>
	<1067447490.1829.30.camel@mulgrave>
	<20031029175045.GC25237@parcelfarce.linux.theplanet.co.uk>
	<1067450547.3112.363.camel@compaq.xsintricity.com>
	<20031029183159.GE25237@parcelfarce.linux.theplanet.co.uk>
	<1067453148.3112.369.camel@compaq.xsintricity.com>
	<4159000000.1067644546@aslan.btc.adaptec.com>
	<1067644902.1782.20.camel@mulgrave>
	<1067645285.3112.538.camel@compaq.xsintricity.com>
	<4168130000.1067645818@aslan.btc.adaptec.com>
	<20031101012231.GA2346@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:12037 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263693AbTKACe0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2003 21:34:26 -0500
In-Reply-To: <20031101012231.GA2346@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <willy@debian.org>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Fri, 2003-10-31 at 19:22, Mike Anderson wrote:
> It is called from scsi_remove_device.

But that's only called for configured devices.  The original intent was
to call slave_destroy for all slave_alloc'd devices (whether configured
or not).

It originally was in scsi_free_sdev, but was moved with

ChangeSet 1.1046.597.3 2003/08/02 12:17:19 andmike@us.ibm.com
  [PATCH] scsi host / scsi device ref counting take 2 [3/3]

The changelog isn't very explicit about why this was done, what was the
particular reason?

James


