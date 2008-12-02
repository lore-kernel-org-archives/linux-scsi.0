From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [patch 10/10] scsi: fix bad use of udelay in atp870u.c
Date: Tue, 2 Dec 2008 07:56:28 +0100
Message-ID: <20081202065628.GH15428@deprecation.cyrius.com>
References: <200812012232.mB1MWGFe019560@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:1088 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbYLBG4j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2008 01:56:39 -0500
Content-Disposition: inline
In-Reply-To: <200812012232.mB1MWGFe019560@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

* akpm@linux-foundation.org <akpm@linux-foundation.org> [2008-12-01 14:32]:
> The ACARD driver calls udelay() with a value > 2000, which leads to
> to the following compilation error on ARM:
>   ERROR: "__bad_udelay" [drivers/scsi/atp870u.ko] undefined!
>   make[1]: *** [__modpost] Error 1
> Fix this by using a combination of mdelay and udelay.

Well, James Bottomley said that this simple patch is wrong, so I guess
you should drop it.  On the other hand, this probably means this build
failure will never get fixed.

Except for this build failure and another, unrelated build failure of
a SCSI module, I managed to get all the build failures I see when
compiling the Debian kernel on ARM and MIPS fixed.  It's a pity the
SCSI folks aren't as responsive as the rest of the world...

-- 
Martin Michlmayr
http://www.cyrius.com/
