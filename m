From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: RE: FW: [PATCH] 2.4.25-pre4 SCSI fusion driver
Date: Thu, 22 Jan 2004 10:55:16 -0200 (BRST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58L.0401221048360.18938@logos.cnet>
References: <53CF1076699CD711B7DD0002A51363F1019032BC@exw-ks.ks.lsil.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from intra.cyclades.com ([64.186.161.6]:42921 "EHLO
	intra.cyclades.com") by vger.kernel.org with ESMTP id S266252AbUAVNII
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 08:08:08 -0500
In-Reply-To: <53CF1076699CD711B7DD0002A51363F1019032BC@exw-ks.ks.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Stephens, Larry" <larry.stephens@lsil.com>
Cc: "Moore, Eric Dean" <Emoore@lsil.com>, "Gibbons, Terry" <Terry.Gibbons@lsil.com>, "'marcelo.tosatti@cyclades.com'" <marcelo.tosatti@cyclades.com>, "'xose@wanadoo.es'" <xose@wanadoo.es>, linux-scsi@vger.kernel.org, "David S. Miller" <davem@redhat.com>



On Tue, 20 Jan 2004, Stephens, Larry wrote:

> Marcelo, I am working on implementing your suggestions for our next driver
> release.
>
> No problem changing __SMP__ to CONFIG_SMP in file linux_compat.h.
>
> The comment about a new header file (which one?) and no GPL:  Are you
> referring to the "GNU General Public License" comments found in several of
> the files?  Is that a requirement now?  It looks like it wasn't in several
> files.  I can copy those comments if needed.

I'm not sure if this is a requirement, but I believe its harmless to have
it. Ok, other files dont have it.

> The change to using CONFIG_COMPAT was suggested by a customer who indicated
> that this would make the driver more general and replace the sparc specific
> code that was previously in the driver.  Do you not agree with the customer
> and/or with how it was implemented for 2.4 kernels?  Or is CONFIG_COMPAT
> strictly a 2.6 kernel feature?  So far, we have received no other feedback
> as a result of this change.

The thing is 2.4 does not define CONFIG_COMPAT. Who defines it? SPARC
users have to do it manually now?

Other than this this looks fine. What tests have been to this
modifications?

> Thanks for your inputs.  I'll be interested in implementing your replies to
> this message.
