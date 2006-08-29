From: Andrew Morton <akpm@osdl.org>
Subject: Re: Conversion to generic boolean
Date: Tue, 29 Aug 2006 08:47:14 -0700
Message-ID: <20060829084714.9ae799a7.akpm@osdl.org>
References: <44EFBEFA.2010707@student.ltu.se>
	<20060828093202.GC8980@infradead.org>
	<20060828171804.09c01846.akpm@osdl.org>
	<20060829114502.GD4076@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:34772 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S964875AbWH2Pre (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 11:47:34 -0400
In-Reply-To: <20060829114502.GD4076@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Richard Knutsson <ricknu-0@student.ltu.se>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 29 Aug 2006 12:45:02 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Aug 28, 2006 at 05:18:04PM -0700, Andrew Morton wrote:
> > At present we have >50 different definitions of TRUE and gawd knows how
> > many private implementations of various flavours of bool.
> > 
> > In that context, Richard's approach of giving the kernel a single
> > implementation of bool/true/false and then converting things over to use it
> > makes sense.  The other approach would be to go through and nuke the lot,
> > convert them to open-coded 0/1.
> > 
> > I'm not particularly fussed either way, really.  But the present situation
> > is nuts.
> 
> Let's start to kill all those utterly silly if (x == true) and if (x == false)
> into if (x) and if (!x) and pospone the type decision.  Adding a bool type
> only makes sense if we have any kind of static typechecking that no one
> ever assign an invalid type to it.

Not really.  bool/true/false have readability advantages over int/1/0.
