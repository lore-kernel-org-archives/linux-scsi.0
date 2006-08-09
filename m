From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 3/3] qla4xxx: iospace_config move defn
Date: Wed, 9 Aug 2006 13:15:34 -0700
Message-ID: <20060809201533.GI7185@andrew-vasquezs-computer.local>
References: <20060809182406.2021.90492.stgit@bebe.enoyolf.org> <20060809184243.2021.48891.stgit@bebe.enoyolf.org> <44DA21BE.3050506@cs.wisc.edu> <1155151384.3850.3.camel@dcslnxpc.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:36934 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751356AbWHIUPg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2006 16:15:36 -0400
Content-Disposition: inline
In-Reply-To: <1155151384.3850.3.camel@dcslnxpc.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Doug Maxey <dwm@enoyolf.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Ravi Anand <ravi.anand@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, David Somayajulu <david.somayajulu@qlogic.com>

On Wed, 09 Aug 2006, David Somayajulu wrote:

> On Wed, 2006-08-09 at 13:56 -0400, Mike Christie wrote:
> > Doug Maxey wrote:
> > > From: Doug Maxey <dwm@enoyolf.org>
> > > 
> > > Move the defn before the caller, and remove the decl.
> > > 
> > 
> > I think not doing the defn before the caller is nice, but I honestly
> > could care less either way as far as merging things goes (it seems like
> > Christoph hates then but people like Jeff let the driver writer do what
> > they want). Qlogic seems to love doing it, so are they ok with all these
> > patches?
> We have no problem with these patches since it makes the code cleaner
> and makes everyone happy.

So, would you folks (Mike/James) like the qla4xxx patches respun with
Doug's changes?  Or will Dave S's original submission be added to
scsi-misc-2.6.git with the fixup/cleanups on top?

Thanks,
AV
