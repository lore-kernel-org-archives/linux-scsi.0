From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND 0/9] zfcp features and bugfixes for 3.10 merge
 window
Date: Fri, 26 Apr 2013 09:10:44 -0700
Message-ID: <1366992644.14612.1.camel@dabdike>
References: <1366985635-38270-1-git-send-email-maier@linux.vnet.ibm.com>
	 <1366989019.1927.2.camel@dabdike> <517AA0E9.6060008@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35470 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755466Ab3DZQKp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Apr 2013 12:10:45 -0400
In-Reply-To: <517AA0E9.6060008@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>

On Fri, 2013-04-26 at 17:44 +0200, Steffen Maier wrote:
> On 04/26/2013 05:10 PM, James Bottomley wrote:
> > On Fri, 2013-04-26 at 16:13 +0200, Steffen Maier wrote:
> >> James,
> >>
> >> here is a series of zfcp features and bugfixes.
> >> We would very much appreciate if you could integrate them for the
> >> upcoming merge window preparing kernel v3.10.
> >> The patches apply on top of the current misc branch of your scsi.git.
> >>
> >> Apparently, I did something wrong on git-send-email so the mails
> >> did not appear on the mailing lists. Apologies for resending.
> >
> > Since no-one saw the originals, apologies aren't necessary.
> > Unfortunately, you're still missing three patches: 5,6,9/9
> 
> Hm, just the patches that had something like this in the signature area:
> Cc: <stable@vger.kernel.org> #2.6.37+
> I guess they got stuck because some MTA or the list do not like what 
> git-send-email converted this into as a CC recipient:
> <stable@vger.kernel.org> #2.6.37+

Hm, that would appear to be a bug in git-send-email.  You can turn off
these with the --suppress-cc=cc flag I think.

> I resent those three as replies to the stuck/lost ones.

Got them now, thanks

James


