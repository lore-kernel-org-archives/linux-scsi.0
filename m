From: Frederik Deweerdt <deweerdt@free.fr>
Subject: Re: [RFC PATCH] move tg3 to pci_request_irq
Date: Mon, 2 Oct 2006 21:04:29 +0000
Message-ID: <20061002210429.GH3003@slug>
References: <1159573404.13029.96.camel@localhost.localdomain> <20060930140946.GA1195@slug> <451F049A.1010404@garzik.org> <20061001142807.GD16272@parisc-linux.org> <1159729523.2891.408.camel@laptopd505.fenrus.org> <20061001193616.GF16272@parisc-linux.org> <1159755141.2891.434.camel@laptopd505.fenrus.org> <20061002200048.GC3003@slug> <20061002201134.GE3003@slug> <20061002182847.GN16272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:65056 "EHLO
	ug-out-1314.google.com") by vger.kernel.org with ESMTP
	id S965351AbWJBTFz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Oct 2006 15:05:55 -0400
Received: by ug-out-1314.google.com with SMTP id o38so543587ugd
        for <linux-scsi@vger.kernel.org>; Mon, 02 Oct 2006 12:05:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20061002182847.GN16272@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org, "Linux-Kernel," <linux-kernel@vger.kernel.org>, "J.A. Magall??n" <jamagallon@ono.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@osdl.org>, Jeff Garzik <jeff@garzik.org>

On Mon, Oct 02, 2006 at 12:28:47PM -0600, Matthew Wilcox wrote:
> On Mon, Oct 02, 2006 at 08:11:34PM +0000, Frederik Deweerdt wrote:
> > @@ -6838,9 +6838,9 @@ restart_timer:
> >  
> >  static int tg3_request_irq(struct tg3 *tp)
> >  {
> > +	struct net_device *dev = tp->dev;
> >  	irqreturn_t (*fn)(int, void *, struct pt_regs *);
> >  	unsigned long flags;
> > -	struct net_device *dev = tp->dev;
> >  
> >  	if (tp->tg3_flags2 & TG3_FLG2_USING_MSI) {
> >  		fn = tg3_msi;
> 
> Is there any reason for this noise?
You mean, besides my awkwardness ? ;)
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
