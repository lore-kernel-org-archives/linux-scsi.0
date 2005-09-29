From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
	the kernel
Date: Thu, 29 Sep 2005 09:44:08 +0200
Message-ID: <1127979848.2918.7.camel@laptopd505.fenrus.org>
References: <43384E28.8030207@adaptec.com> <4339BFE9.1060604@pobox.com>
	 <4339CCD6.5010409@adaptec.com> <4339F9A8.2030709@pobox.com>
	 <433AFEB2.7090003@adaptec.com> <433B0457.7020509@pobox.com>
	 <433B14E1.6080201@adaptec.com> <433B217F.4060509@pobox.com>
	 <20050929040403.GE18716@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37846 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932184AbVI2HoM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 03:44:12 -0400
In-Reply-To: <20050929040403.GE18716@alpha.home.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willy Tarreau <willy@w.ods.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Luben Tuikov <luben_tuikov@adaptec.com>, Jeff Garzik <jgarzik@pobox.com>

On Thu, 2005-09-29 at 06:04 +0200, Willy Tarreau wrote:
> On Wed, Sep 28, 2005 at 07:04:31PM -0400, Jeff Garzik wrote:
> > Linux is about getting things done, not being religious about 
> > specifications.  You are way too focused on the SCSI specs, and missing 
> > the path we need to take to achieve additional flexibility.
> > 
> > With Linux, it's all about evolution and the path we take.
> 
> Hmmm... I'm fine with "not being religious about specs", but I hope we
> try to respect them as much as possible

a spec describes how the hw works... how we do the sw piece is up to
us ;)

(I know the scsi stuff also provides sort of a reference "here is how
you can do it in sw" but I see that more as you "you need this
functionality" not "you need this exact architecture in your software")

