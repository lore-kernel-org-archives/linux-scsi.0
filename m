From: greg@enjellic.com
Subject: Re: Poisoning of Linux initiators on SCST reboot.
Date: Fri, 1 Aug 2008 15:22:23 -0500
Message-ID: <200808012022.m71KMNDX004852@wind.enjellic.com>
References: <andrew.vasquez@qlogic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([209.243.13.15]:38133 "EHLO
	wind.enjellic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbYHAUW5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2008 16:22:57 -0400
In-Reply-To: Andrew Vasquez <andrew.vasquez@qlogic.com>
       "Re: Poisoning of Linux initiators on SCST reboot." (Jul 29, 11:19am)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: scst-devel@lists.sourceforge.net, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, stf_xl@wp.pl, vst@vlnb.net

On Jul 29, 11:19am, Andrew Vasquez wrote:
} Subject: Re: Poisoning of Linux initiators on SCST reboot.

Good afternoon to everyone, hope the week is ending well.

> Ok, here's a patch against Linus' latest git tree which corrects the
> issue locally.  Could you try it out on your test configuration?
> We'd like to perform some additional sanity-testing locally before
> we submit the fix formally for upstream consumption.

The patch worked perfectly on our test configuration.  After the SCST
target reboot the client initiator picked up on the presence of the
storage and properly discovered it.

Evidently the qla2xxx driver has changed significantly from where
Linus' tree was at when you sent the patch.  My local git clone is up
to date with Linus' git tree which has
94ad374a0751f40d25e22e036c37f7263569d24c at its head and the patch
didn't apply.

The kernel I tested against was from my local git clone of Linus' tree
which has 94ad374a0751f40d25e22e036c37f7263569d24c at its head.  The
qla2xxx driver has evidently changed significantly since the patch
didn't apply cleanly against this tree.  It was trivial, however, to
update the patch.

> Sidenote: we'll also need to backport some form of this fix to
> stable, but qla2xxx in kernels upto 2.6.26 didn't utilize the
> terminate-rport-io infrastructure:

That would seem to be the case.  It doesn't appear 2.6.26 even has the
necessary infra-structure to support the patch.

Any idea on how tough a backport to 2.6.26 or earlier would be?
Running 'head-of-git' from Linus' tree would be somewhat of a stretch
for production applications.... :-)(

Thanks for the timely response.  Let me know if we can help out with
any additional testing.

Best wishes for a pleasant weekend.

}-- End of excerpt from Andrew Vasquez

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"There's no such thing as a wizard who minds his own business."
                                -- Berengis the Black Court Mage
                                   to the Earls Caeline
