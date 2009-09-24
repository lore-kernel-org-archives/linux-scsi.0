From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 2/14] bfa: Brocade BFA FC SCSI driver (bfa1)
Date: Thu, 24 Sep 2009 10:38:53 -0700
Message-ID: <B0A7AF226B49A14897036E9B3A68CFFECB1AB0F77D@HQ-EXCH-7.corp.brocade.com>
References: <200909240049.n8O0nw3l013437@swe58.brocade.com>
 <1253807042.20648.188.camel@desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753066AbZIXRi4@vger.kernel.org>
In-Reply-To: <1253807042.20648.188.camel@desktop>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Walker <dwalker@fifo99.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, Krishna Gudipati <kgudipat@Brocade.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>
List-Id: linux-scsi@vger.kernel.org

> On Wed, 2009-09-23 at 17:49 -0700, Jing Huang wrote:
> > +
> > +       return (*(union bfi_addr_u *) &addr);
> > +}
> 
> Have you run checkpatch on this code? It produces many errors due to
> your "return" usage for one.. The usual style of return is not to use
> parentheses since it's really not a function ..
> 
> The line I quoted above gives the following error,
> 
> ERROR: return is not a function, parentheses are not required
> #266: FILE: drivers/scsi/bfa/bfa_cb_ioim_macros.h:132:
> +       return (*(union bfi_addr_u *) &addr);
> 
> First of all I'd consider making your code consistent with respect to
> the return statements .. I noticed that you sometimes use the
> parentheses sometimes not .. Since it's more with Linux style I'd just
> remove all the extra parentheses..
> 
> Checkpatch produces many other errors in your code .. If you haven't
> already evaluated those errors, I'd do go through each patch and review
> the errors (and the warnings) that it produces since checkpatch can give
> you a fairly mechanical view into how well your code matches the Linux
> coding style. The less the output from checkpatch the better ..
> 
> Daniel
> 

Hi Daniel, 

I did run checkpatch.pl and it didn't report any ERROR or WARNING. Do you use any specific flags?

Thanks

Jing
