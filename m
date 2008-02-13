From: Matthias Kaehlcke <matthias@kaehlcke.net>
Subject: Re: [PATCH] Adaptec AACRAID: convert fibctx->wait_sem to completion
Date: Wed, 13 Feb 2008 21:15:33 +0100
Message-ID: <20080213201533.GC27068@traven>
References: <20080213183444.GA27068@traven> <1202929740.3109.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.riseup.net ([204.13.164.18]:46862 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075AbYBMUP1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 15:15:27 -0500
Content-Disposition: inline
In-Reply-To: <1202929740.3109.79.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: aacraid@adaptec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

El Wed, Feb 13, 2008 at 01:09:00PM -0600 James Bottomley ha dit:

> On Wed, 2008-02-13 at 19:34 +0100, Matthias Kaehlcke wrote:
> > Adaptec AACRAID driver: The semaphore fibctx->wait_sem is used for
> > signalling an event. Convert it to a completion.
> 
> What's the purpose of doing this?  The aacraid implementation seems to
> be a classic PV semaphore, so why does it need to become a completion?

i had another look at the code and i agree with you. i didn't realize that
the semaphore is used as counting semaphore

please redirect the patch to /dev/null

thanks for reviewing the patch and pointing out my mistake

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

      In itself, homosexuality is as limiting as heterosexuality: the
     ideal should be to be capable of loving a woman or a man; either,
      a human being, without  feeling fear, restraint, or obligation
                          (Simone de Beauvoir)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
