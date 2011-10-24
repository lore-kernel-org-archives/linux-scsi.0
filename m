From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in
 pmcraid_chr_ioctl()
Date: Mon, 24 Oct 2011 16:07:05 -0700
Message-ID: <1319497625.2094.4.camel@Joe-Laptop>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net>
	 <1319496149.2094.3.camel@Joe-Laptop>
	 <CAFLxGvyh-u0Bg5_R4upMa=bM4H__i=dbvtLihFY+M+OEKdJL9w@mail.gmail.com>
	 <alpine.LNX.2.00.1110250055310.19795@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:34254 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754293Ab1JXXHG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2011 19:07:06 -0400
In-Reply-To: <alpine.LNX.2.00.1110250055310.19795@swampdragon.chaosbits.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, davej@redhat.com

On Tue, 2011-10-25 at 00:57 +0200, Jesper Juhl wrote:
> On Tue, 25 Oct 2011, richard -rw- weinberger wrote:
> > On Tue, Oct 25, 2011 at 12:42 AM, Joe Perches <joe@perches.com> wrote:
> > > On Tue, 2011-10-25 at 00:38 +0200, Jesper Juhl wrote:
> > BTW: What about a checkpatch.pl rule to detect such a misuse of kmalloc()?
> > We could grep for "k[mzc]alloc(GFP_".
> > 
> I like that idea. That's exactely how I find these; by doing 
> egrep -R "[kv][mcz]alloc *\( *GFP_" 
> on the source tree.
> Might as well be in checkpatch.pl

Well, also from a year ago...

https://lkml.org/lkml/2010/10/31/121




