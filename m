From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: Fri, 31 Oct 2003 19:02:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067644949.3112.536.camel@compaq.xsintricity.com>
References: <1067447221.3112.336.camel@compaq.xsintricity.com>
	 <1067447490.1829.30.camel@mulgrave>
	 <20031029175045.GC25237@parcelfarce.linux.theplanet.co.uk>
	 <1067450547.3112.363.camel@compaq.xsintricity.com>
	 <20031029183159.GE25237@parcelfarce.linux.theplanet.co.uk>
	 <1067453148.3112.369.camel@compaq.xsintricity.com>
	 <4159000000.1067644546@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:10259 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261294AbTKAADt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2003 19:03:49 -0500
In-Reply-To: <4159000000.1067644546@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Matthew Wilcox <willy@debian.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Fri, 2003-10-31 at 18:55, Justin T. Gibbs wrote:
> > Yeah, the appropriate time to check that bit would be at
> > slave_configure() time.  (Hmmm...I should have documented that...)
> 
> BTW, slave_destroy() doesn't seem to be called after a probe
> for a target fails due to a selection timeout.  Is this the
> expected behavior?  I only keep persistent allocations after
> slave_configure() is called, so this doesn't affect my drivers,
> but the behavior isn't what I expected.  This is 2.6.0-test9.

I haven't been able to follow 2.5/2.6 SCSI stuff as close as I wanted,
but originally I thought it did call slave_destroy() even if it never
called slave_configure()....hmmm...maybe I should go check my stuff back
then...I could be wrong on that.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


