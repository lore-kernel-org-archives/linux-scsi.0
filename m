From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 01/17] git-scsi-misc: arcmsr build fix
Date: Fri, 05 Oct 2007 17:16:31 -0400
Message-ID: <1191618991.3475.30.camel@localhost.localdomain>
References: <200710022137.l92LbxEw023552@imap1.linux-foundation.org>
	 <20071005120700.45630fac.akpm@linux-foundation.org>
	 <1191617362.3475.17.camel@localhost.localdomain>
	 <20071005140412.21452aa0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55313 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763227AbXJEVQd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 17:16:33 -0400
In-Reply-To: <20071005140412.21452aa0.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org

On Fri, 2007-10-05 at 14:04 -0700, Andrew Morton wrote:
> On Fri, 05 Oct 2007 16:49:22 -0400
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > On Fri, 2007-10-05 at 12:07 -0700, Andrew Morton wrote:
> > > I sent seventeen patches and only one was applied.
> > > 
> > > Please either merge the others or give them a nack-with-reasons or specify
> > > how they need to be altered.
> > > 
> > > Please do not just ignore them.  This creates additional ongoing
> > > maintenance work for myself.
> > 
> > Actually, none were applied ...
> 
> ok, mpt-fusion-shut-up-uninitialized-variable.patch arrive in your tree via
> some other route and confused me.
> 
> > you just got a fortuitous match with one
> > of Matthew's advansys patches, like he said you would.  Yours are in the
> > queue behind the gdth patch set which is currently causing me merge
> > problems.  Once I get that sorted out, I'll likely apply all of yours
> > bar the ones I already replied about.
> 
> OK, thanks.
> 
> wrt the ones you already replied about: I'm unsure which those are so can
> you please re-reply?  I'd prefer to drop marginal stuff rather than having
> it hang around for ever.

It was just the aic7xxx one (8/17).  I'll resend.

James


