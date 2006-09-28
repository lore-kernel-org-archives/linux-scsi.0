From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Illustration of warning explosion silliness
Date: Wed, 27 Sep 2006 21:47:19 -0700
Message-ID: <20060927214719.cbeebaf4.akpm@osdl.org>
References: <20060928005830.GA25694@havoc.gtf.org>
	<20060927183507.5ef244f3.akpm@osdl.org>
	<451B29FA.7020502@garzik.org>
	<20060927203417.f07674de.akpm@osdl.org>
	<451B4D58.9070401@garzik.org>
	<20060927213628.ef12b1ed.akpm@osdl.org>
	<451B52B0.1090801@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:32445 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751313AbWI1Er3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Sep 2006 00:47:29 -0400
In-Reply-To: <451B52B0.1090801@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>

On Thu, 28 Sep 2006 00:42:24 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> This thing introduces endless build noise we won't 
> kill for years, making it much harder to spot much more serious stuff.

That's true, and it hurt.  But there are a lot of real bugs in there.

I thought of adding a stricter __must_check like

#ifdef CONFIG_MUST_CHECK_ANAL
#define __must_check_anal __must_check
#else
#define __must_check_anal
#endif

which we can still do, of course.

But it'd be better to fix the bugs...
