From: Matthew Wilcox <willy@debian.org>
Subject: Re: Bug in the sg driver
Date: Tue, 7 Oct 2003 13:26:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007122623.GJ24824@parcelfarce.linux.theplanet.co.uk>
References: <20031007115600.GH24824@parcelfarce.linux.theplanet.co.uk> <20031007120355.19343.qmail@dag.newtech.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:59342 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262285AbTJGM0Y
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2003 08:26:24 -0400
Content-Disposition: inline
In-Reply-To: <20031007120355.19343.qmail@dag.newtech.fi>
List-Id: linux-scsi@vger.kernel.org
To: Dag Nygren <dag@newtech.fi>
Cc: Matthew Wilcox <willy@debian.org>, "Randy.Dunlap" <rddunlap@osdl.org>, linux-scsi@vger.kernel.org

On Tue, Oct 07, 2003 at 03:03:55PM +0300, Dag Nygren wrote:
> > On Tue, Oct 07, 2003 at 08:47:00AM +0300, Dag Nygren wrote:
>  
> > Then you really should be taking these problems up with Red Hat,
> > not with us.
> 
> So you mean that this bug is squished in 2.4.22 then? 

Not necessarily.  Red Hat's kernels contain a lot of customisations and
changes versus the stock Linux tree.  It's almost impossible for us to
debug problems in Red Hat's kernel.  It's possible (though unlikely)
the bug was even introduced by Red Hat.

In any case, if you need a Red Hat supplied kernel, you need to work
with Red Hat.  There's really no way around that.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
