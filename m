From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH RESEND 0/9] zfcp features and bugfixes for 3.10 merge
 window
Date: Sat, 27 Apr 2013 11:44:09 +0200
Message-ID: <20130427094409.GA3588@osiris>
References: <1366985635-38270-1-git-send-email-maier@linux.vnet.ibm.com>
 <1366989019.1927.2.camel@dabdike>
 <517AA0E9.6060008@linux.vnet.ibm.com>
 <1366992644.14612.1.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:44204 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab3D0Jot (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Apr 2013 05:44:49 -0400
Received: from /spool/local
	by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
	Sat, 27 Apr 2013 10:41:33 +0100
Content-Disposition: inline
In-Reply-To: <1366992644.14612.1.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>

On Fri, Apr 26, 2013 at 09:10:44AM -0700, James Bottomley wrote:
> On Fri, 2013-04-26 at 17:44 +0200, Steffen Maier wrote:
> > On 04/26/2013 05:10 PM, James Bottomley wrote:
> > > On Fri, 2013-04-26 at 16:13 +0200, Steffen Maier wrote:
> > >> James,
> > >>
> > >> here is a series of zfcp features and bugfixes.
> > >> We would very much appreciate if you could integrate them for the
> > >> upcoming merge window preparing kernel v3.10.
> > >> The patches apply on top of the current misc branch of your scsi.git.
> > >>
> > >> Apparently, I did something wrong on git-send-email so the mails
> > >> did not appear on the mailing lists. Apologies for resending.
> > >
> > > Since no-one saw the originals, apologies aren't necessary.
> > > Unfortunately, you're still missing three patches: 5,6,9/9
> > 
> > Hm, just the patches that had something like this in the signature area:
> > Cc: <stable@vger.kernel.org> #2.6.37+
> > I guess they got stuck because some MTA or the list do not like what 
> > git-send-email converted this into as a CC recipient:
> > <stable@vger.kernel.org> #2.6.37+
> 
> Hm, that would appear to be a bug in git-send-email.  You can turn off
> these with the --suppress-cc=cc flag I think.

FWIW, I just installed git 1.8.1.6 on the machine these patches were sent
from. That version doesn't seem to have the problem:

The Cc recipient looks sane (tested with --dry-run):

<stable@vger.kernel.org>

