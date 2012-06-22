From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: lpfc: problems with -Werror
Date: Fri, 22 Jun 2012 22:58:35 +0100
Message-ID: <1340402315.19210.14.camel@dabdike.int.hansenpartnership.com>
References: <20120621013018.GA7244@localhost>
	 <1340265001.2985.13.camel@dabdike.int.hansenpartnership.com>
	 <20120622184626.GA3536@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39410 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927Ab2FVV6k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jun 2012 17:58:40 -0400
In-Reply-To: <20120622184626.GA3536@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Alex Iannicelli <alex.iannicelli@emulex.com>, James Smart <james.smart@emulex.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2012-06-22 at 12:46 -0600, Matthew Wilcox wrote:
> On Thu, Jun 21, 2012 at 07:50:02AM +0000, James Bottomley wrote:
> > @@ -22,7 +22,9 @@
> >  ccflags-$(GCOV) := -fprofile-arcs -ftest-coverage
> >  ccflags-$(GCOV) += -O0
> >  
> > +ifdef WARNINGS_BECOME_ERRORS
> >  ccflags-y += -Werror
> > +endif
> >  
> >  obj-$(CONFIG_SCSI_LPFC) := lpfc.o
> 
> Why not more simply:
> 
> ccflags-$(WARNINGS_BECOME_ERRORS) += -Werror

Because it's not a config option, it's a makefile option.  If we go with
what you propose, the format of make has to be

make WARNINGS_BECOME_ERRORS=y

which is a bit non intuitive.

> > N?????r??y????b?X????v?^?)??{.n?+????{???"?{ay?
?????,j??f???h???z?
?w???
???j:+v???w?j?m????????zZ+???????j"??!
> 
> That's some nasty line noise on your modem there, James.

No, it's because majordomo has some issue doing base64.

James



