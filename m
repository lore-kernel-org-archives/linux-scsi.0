From: Chris Adams <cmadams@hiwaay.net>
Subject: Re: Why are MegaRAID drivers mutually exclusive?
Date: Thu, 11 Nov 2004 08:42:10 -0600
Message-ID: <20041111144210.GD1508368@hiwaay.net>
References: <0E3FA95632D6D047BA649F95DAB60E570562C174@exa-atlanta> <20041110220854.GB28524@lists.us.dell.com> <1100160080.2646.10.camel@laptop.fenrus.org> <20041111140745.GA1508368@hiwaay.net> <1100183048.4387.11.camel@laptop.fenrus.org> <20041111143157.GC1508368@hiwaay.net> <1100183986.4387.13.camel@laptop.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bee.hiwaay.net ([216.180.54.11]:9001 "EHLO bee.hiwaay.net")
	by vger.kernel.org with ESMTP id S262240AbUKKOmU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2004 09:42:20 -0500
Content-Disposition: inline
In-Reply-To: <1100183986.4387.13.camel@laptop.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>, "Mukker, Atul" <Atulm@lsil.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Once upon a time, Arjan van de Ven <arjan@infradead.org> said:
> On Thu, 2004-11-11 at 08:31 -0600, Chris Adams wrote:
> > Once upon a time, Arjan van de Ven <arjan@infradead.org> said:
> > > the difference is that in those situations the new driver supported all
> > > old hw too; while here... well.. you legitamitly can have an old and new
> > > megaraid card in the same server (say you had two and one got replaced 2
> > > years later)
> > 
> > Then you use the old driver.  If you have an old card, you will be using
> > the old driver anyway; it should just keep working.
> 
> but then the new controller doesn't work. because for that one you need
> the new driver.

Currently, the old driver works for all cards, old and new.  Someone has
suggested removing the PCI IDs that the new driver handles from the old
driver; if that is _not_ done, the old driver will continue to work for
all cards, old and new.

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
