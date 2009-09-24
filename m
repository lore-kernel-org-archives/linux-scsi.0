From: Daniel Walker <dwalker@fifo99.com>
Subject: Re: [PATCH 2/14] bfa: Brocade BFA FC SCSI driver (bfa1)
Date: Thu, 24 Sep 2009 09:15:35 -0700
Message-ID: <1253808935.20648.211.camel@desktop>
References: <200909240049.n8O0nw3l013437@swe58.brocade.com>
	 <1253807042.20648.188.camel@desktop>
	 <20090924165944.6507432a@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fifo99.com ([67.223.236.141]:49840 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbZIXQPr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Sep 2009 12:15:47 -0400
In-Reply-To: <20090924165944.6507432a@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jing Huang <huangj@brocade.com>, James.Bottomley@HansenPartnership.com, kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

On Thu, 2009-09-24 at 16:59 +0100, Alan Cox wrote:
> > > +       return (*(union bfi_addr_u *) &addr);
> > > +}
> > 
> > Have you run checkpatch on this code? It produces many errors due to
> > your "return" usage for one.. The usual style of return is not to use
> > parentheses since it's really not a function ..
> 
> checkpatch is just a helper tool - and stuff like that using
> brackets to make it clearer is just a trivial matter of style.

True, but I do care about the style of code .. You may not care about it
which is fine ..

> > Checkpatch produces many other errors in your code .. If you haven't
> > already evaluated those errors
> 
> It would be rather more useful if instead of parroting checkpatch results
> (which people can generate themselves) you concentrated on analysis the
> actual code and structure for any flaws and design details.

They can generate them , but don't seem too .. For me, these problems
distract from the overall design .. I find it hard to focus on reviewing
larger topics like that when I know the trivial code clean ups have not
been done.. It's much easier to review clean code than code which has
lots of style problems.

> Trivia like coding style (unless particularly bad) are something for the
> maintainer just to say "fix those odd bits up and I'll merge it" at the
> *end*.

Well, isn't this the end for this patch set? He's asking for inclusion
in this thread, and it's been submitted once before already .. He has
also received enough comments for another round , so there isn't any
reason not to add the style clean ups, if any, to the next one.

Daniel

