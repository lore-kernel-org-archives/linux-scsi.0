From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/14] bfa: Brocade BFA FC SCSI driver (bfa1)
Date: Thu, 24 Sep 2009 16:59:44 +0100
Message-ID: <20090924165944.6507432a@lxorguk.ukuu.org.uk>
References: <200909240049.n8O0nw3l013437@swe58.brocade.com>
	<1253807042.20648.188.camel@desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40000 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751282AbZIXP6b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2009 11:58:31 -0400
In-Reply-To: <1253807042.20648.188.camel@desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Walker <dwalker@fifo99.com>
Cc: Jing Huang <huangj@brocade.com>, James.Bottomley@HansenPartnership.com, kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

> > +       return (*(union bfi_addr_u *) &addr);
> > +}
> 
> Have you run checkpatch on this code? It produces many errors due to
> your "return" usage for one.. The usual style of return is not to use
> parentheses since it's really not a function ..

checkpatch is just a helper tool - and stuff like that using
brackets to make it clearer is just a trivial matter of style.

> Checkpatch produces many other errors in your code .. If you haven't
> already evaluated those errors

It would be rather more useful if instead of parroting checkpatch results
(which people can generate themselves) you concentrated on analysis the
actual code and structure for any flaws and design details.

Trivia like coding style (unless particularly bad) are something for the
maintainer just to say "fix those odd bits up and I'll merge it" at the
*end*.

