From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 10/11] scsi: fix bad use of udelay in atp870u.c
Date: Fri, 9 Jan 2009 13:03:08 -0800
Message-ID: <20090109130308.bfde281e.akpm@linux-foundation.org>
References: <200901092028.n09KSAeI024551@imap1.linux-foundation.org>
	<20090109205835.GB5069@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753471AbZAIVDO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2009 16:03:14 -0500
In-Reply-To: <20090109205835.GB5069@deprecation.cyrius.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Michlmayr <tbm@cyrius.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Fri, 9 Jan 2009 21:58:35 +0100
Martin Michlmayr <tbm@cyrius.com> wrote:

> * akpm@linux-foundation.org <akpm@linux-foundation.org> [2009-01-09 12:28]:
> > The ACARD driver calls udelay() with a value > 2000, which leads to
> > to the following compilation error on ARM:
> >   ERROR: "__bad_udelay" [drivers/scsi/atp870u.ko] undefined!
> >   make[1]: *** [__modpost] Error 1
> > Fix this by using a combination of mdelay and udelay.
> 
> James already said that this patch is wrong,

Well, it's not "wrong" - it has no runtime effect - it just fixes the build.

> so I suggest you drop
> this patch. (Even if this will probably mean that this issue will
> never get addressed.)

shrug.
