From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: Scsi midlayer question
Date: Tue, 10 Aug 2004 09:40:22 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040810124022.GD11276@logos.cnet>
References: <47F3C2BE74738E4683574107469DFA204CC4FA@XYUSEX01.xyus.xyratex.com> <1090001284.2805.10.camel@laptop.fenrus.com> <20040809223956.GB8782@logos.cnet> <20040810080556.GA12711@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:33763 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266220AbUHJNov
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2004 09:44:51 -0400
Content-Disposition: inline
In-Reply-To: <20040810080556.GA12711@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: Frank Borich <Frank_Borich@us.xyratex.com>, linux-scsi@vger.kernel.org

On Tue, Aug 10, 2004 at 10:05:57AM +0200, Arjan van de Ven wrote:
> On Mon, Aug 09, 2004 at 07:39:56PM -0300, Marcelo Tosatti wrote:
> > >  		BUG();
> > 
> > Arjan, is this a v2.6 based patch? 
> 
> no a 2.4.21-era patch
> 
>  
> > v2.4 current doesnt contain such code you are patching...
> 
> it'll have code quite similar, I mean this code hardly changed since 2.4.0
> and 2.6.x until this patch got merged.

Should have read the code before replying, OK now I see, its wli's discover
to not handle higher order pages in "reverse order" but instead
in "order", yes?

Have you done any tests with it on v2.4 based kernels? 

I'm a bit skeptic about it though.

Frank, can you try this patch?



