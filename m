From: Doug Ledford <dledford@redhat.com>
Subject: Re: SCSI Disk layer performance
Date: Mon, 02 Feb 2004 13:23:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075746206.3248.9.camel@compaq.xsintricity.com>
References: <1074720667.19927.384.camel@localhost.lnxi.com>
	 <20040122135703.A11283@infradead.org> <4010FF56.2060806@cri74.org>
	 <20040129185906.C11929@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:29649 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265772AbUBBSXc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2004 13:23:32 -0500
In-Reply-To: <20040129185906.C11929@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Fabien Salvi <fabien@cri74.org>, linux-scsi mailing list <linux-scsi@vger.kernel.org>, Marcelo Tosatti <marcelo.tosatti@cyclades.com>

On Thu, 2004-01-29 at 13:59, Christoph Hellwig wrote:
> On Fri, Jan 23, 2004 at 12:02:46PM +0100, Fabien Salvi wrote:
> > > What kernel tree do you use?  If you're looking for decent scsi
> > > performance use linux 2.6 or the SuSE/RH vendor trees.  Stock Linux 2.4
> > > is basically unusable for higher scsi loads in SMP enviroments.
> > 
> > Can you give more details about this ?
> > 
> > Instead of using vendor trees, is it possible to use specific and 
> > validated patchs about this ?
> 
> It's rather hard as there's a lot of them and they depend on each other.
> Doug Ledford sayd he's going to sort put it into the 2.4 BK repos
> at linux-scsi.bkbits.net one day, you could monitor it.

Yes, I'm still working on it.  The sheer number of changes we make to
the SCSI stack internally makes it difficult to sort the bug fixes from
all the other stuff.  And, of course, if you call totally piss poor SCSI
performance a bug, then a lot of the patches are in fact bug fixes since
they drastically impact the 2.4 SCSI stack speed ;-)

In any case, I've sorted out the bare bugfixes (which is relatively
small actually), and am now putting together the 2.4-everything tree
that has all the scsi stuff in it.  Keep in mind that it isn't just a
"throw our patches on the current 2.4 bk tree from Marcelo".  I have to
merge the patches and check for areas where new code between 2.4.21 and
current makes the things like the iorl patch have bugs.

Anyway, it's coming.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


