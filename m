From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7x_x_x 6.3.4 && Aic79xx 2.0.5 Updates
Date: Sat, 27 Dec 2003 08:47:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3327750000.1072540064@aslan.btc.adaptec.com>
References: <1051920000.1054684267@aslan.btc.adaptec.com>	 <3637050000.1054690456@aslan.s			csiguy.com>	 <2113050000.1072285128@aslan.scsiguy.com>	 <1072288242.1906.35.camel@mulgrave		>	 <2148850000.1072292121@aslan.scsiguy.com>	 <1072292714.2415.39.camel@mulgrave	>	 <2304040000.1072326693@aslan.scsiguy.com>	 <1072463795.1873.127.camel@mulgrave>	 <2832150000.1072484024@aslan.scsiguy.com>	 <1072495231.1873.363.camel@mulgrave>	 <2906490000.1072499170@aslan.scsiguy.com> <1072537914.5494.5.camel@dhcp23.swansea.linux.org.uk>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:31911 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S264419AbTL0PmT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Dec 2003 10:42:19 -0500
In-Reply-To: <1072537914.5494.5.camel@dhcp23.swansea.linux.org.uk>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, Andrew Morton <akpm@osdl.org>

> On Sad, 2003-12-27 at 04:26, Justin T. Gibbs wrote:
>> I'm sorry you feel that way.  I suppose I will just have to continue
>> to point distributors and users of this driver to my own patch sets since
>> that seems to be the only viable alternative you've given me.
>
> Is that an official Adaptec statement, or should I ask Adaptec if they
> can assist in resolving this matter ?
 
That is my statement.  You can escalate this matter to whatever formum
you feel is most appropriate.
 
That said, Adaptec's typical stance on these matters is that if a change
is required to these drivers in order to make them work correctly
(i.e. something required by a major customer) that for some reason is not
embedded, that providing separate DUD/RPM/SRC distributions to
our customers is sufficient.  This change is no different.  The current
SCSI layer offers no other alternative to having fully functional watchdog
recovery.  This is not a new revelation and my drivers are not the first
to take *extreme measures* to try and avoid the brokenness.  The changes
were not made in an attempt to be inflammatory, they were made to fix
real field issues that could be resolved within the driver in no other way.
 
James seems to imply that it is my responsibility as a "good open source
developer" to "contribute" the fixes to the SCSI layer to correct these
issues.  I would think that the SCSI layer maintainer would not only
understand these issues, but take up the charge of discussing and correcting
them.  Since we don't agree, on a fundamental level, on what the problem is
much less how to fix it, I think that having me go off and come up with fixes
would be counter productive to all involved.
 
If there is sincere interest in correcting error recovery in the Linux
SCSI layer, I'm still more than happy to give input and perhaps even
provide code.  But to say that I cannot embed a driver that has to skirt
mid-layer brokenness in order to be fully functional - regardless of how
it does that - until that brokenness can be corrected, is a disservice to
all users of this hardware.
 
--
Justin

