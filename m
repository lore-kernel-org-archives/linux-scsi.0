From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 01/17] git-scsi-misc: arcmsr build fix
Date: Fri, 5 Oct 2007 14:04:12 -0700
Message-ID: <20071005140412.21452aa0.akpm@linux-foundation.org>
References: <200710022137.l92LbxEw023552@imap1.linux-foundation.org>
	<20071005120700.45630fac.akpm@linux-foundation.org>
	<1191617362.3475.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbXJEVER (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 17:04:17 -0400
In-Reply-To: <1191617362.3475.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 05 Oct 2007 16:49:22 -0400
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Fri, 2007-10-05 at 12:07 -0700, Andrew Morton wrote:
> > I sent seventeen patches and only one was applied.
> > 
> > Please either merge the others or give them a nack-with-reasons or specify
> > how they need to be altered.
> > 
> > Please do not just ignore them.  This creates additional ongoing
> > maintenance work for myself.
> 
> Actually, none were applied ...

ok, mpt-fusion-shut-up-uninitialized-variable.patch arrive in your tree via
some other route and confused me.

> you just got a fortuitous match with one
> of Matthew's advansys patches, like he said you would.  Yours are in the
> queue behind the gdth patch set which is currently causing me merge
> problems.  Once I get that sorted out, I'll likely apply all of yours
> bar the ones I already replied about.

OK, thanks.

wrt the ones you already replied about: I'm unsure which those are so can
you please re-reply?  I'd prefer to drop marginal stuff rather than having
it hang around for ever.

Thanks.
