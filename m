From: Frederik Deweerdt <deweerdt@free.fr>
Subject: Re: [RFC PATCH] move drm to pci_request_irq
Date: Mon, 2 Oct 2006 22:26:25 +0000
Message-ID: <20061002222625.GK3003@slug>
References: <1159573404.13029.96.camel@localhost.localdomain> <20060930140946.GA1195@slug> <451F049A.1010404@garzik.org> <20061001142807.GD16272@parisc-linux.org> <1159729523.2891.408.camel@laptopd505.fenrus.org> <20061001193616.GF16272@parisc-linux.org> <1159755141.2891.434.camel@laptopd505.fenrus.org> <20061002200048.GC3003@slug> <20061002201229.GF3003@slug> <1159821398.8907.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:36385 "EHLO
	ug-out-1314.google.com") by vger.kernel.org with ESMTP
	id S964994AbWJBU1v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Oct 2006 16:27:51 -0400
Received: by ug-out-1314.google.com with SMTP id o38so553814ugd
        for <linux-scsi@vger.kernel.org>; Mon, 02 Oct 2006 13:27:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1159821398.8907.57.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, "Linux-Kernel," <linux-kernel@vger.kernel.org>, "J.A. Magall??n" <jamagallon@ono.com>, Andrew Morton <akpm@osdl.org>, Jeff Garzik <jeff@garzik.org>

On Mon, Oct 02, 2006 at 09:36:38PM +0100, Alan Cox wrote:
> Ar Llu, 2006-10-02 am 20:12 +0000, ysgrifennodd Frederik Deweerdt:
> > Hi,
> > 
> > This proof-of-concept patch converts the drm driver to use the
> > pci_request_irq() function.
> 
> 0 isn't invalid - it means no IRQ was assigned so wants a different
> message.
> 
I understand, what about:

("No usable irq line was found (got #%d)\n", irqno)

This is generic enough, so that if on some arches a given irq (other
than 0) is invalid, the message still makes sense.
