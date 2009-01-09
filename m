From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [patch 10/11] scsi: fix bad use of udelay in atp870u.c
Date: Fri, 9 Jan 2009 21:58:35 +0100
Message-ID: <20090109205835.GB5069@deprecation.cyrius.com>
References: <200901092028.n09KSAeI024551@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:4177 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846AbZAIV2P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jan 2009 16:28:15 -0500
Content-Disposition: inline
In-Reply-To: <200901092028.n09KSAeI024551@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

* akpm@linux-foundation.org <akpm@linux-foundation.org> [2009-01-09 12:28]:
> The ACARD driver calls udelay() with a value > 2000, which leads to
> to the following compilation error on ARM:
>   ERROR: "__bad_udelay" [drivers/scsi/atp870u.ko] undefined!
>   make[1]: *** [__modpost] Error 1
> Fix this by using a combination of mdelay and udelay.

James already said that this patch is wrong, so I suggest you drop
this patch. (Even if this will probably mean that this issue will
never get addressed.)
-- 
Martin Michlmayr
http://www.cyrius.com/
